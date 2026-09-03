"""Route endpoints: search, detail, ordered stops, shape, trips by date.

Route 1 = line "2" (Gjorche Petrov - Novo Lisice, 13 stops per direction,
weekday headway 20 min from 06:00 to 23:00 plus one night trip per direction).
"""

from httpx import AsyncClient

LINE_2 = 1


async def test_route_search(client: AsyncClient) -> None:
    response = await client.get("/api/v1/routes", params={"search": "gjorche"})
    assert response.status_code == 200
    body = response.json()
    assert body["total"] == 1
    assert body["items"][0]["short_name"] == "2"


async def test_route_list_all(client: AsyncClient) -> None:
    response = await client.get("/api/v1/routes")
    body = response.json()
    assert body["total"] == 5
    assert {r["short_name"] for r in body["items"]} == {"2", "5", "15", "22", "24"}


async def test_route_detail(client: AsyncClient) -> None:
    response = await client.get(f"/api/v1/routes/{LINE_2}")
    assert response.status_code == 200
    body = response.json()
    assert body["short_name"] == "2"
    assert body["agency_name"] == "CityBus Skopje"


async def test_route_not_found(client: AsyncClient) -> None:
    response = await client.get("/api/v1/routes/999")
    assert response.status_code == 404


async def test_route_ordered_stops(client: AsyncClient) -> None:
    response = await client.get(f"/api/v1/routes/{LINE_2}/stops", params={"direction_id": 0})
    assert response.status_code == 200
    stops = response.json()
    assert len(stops) == 13
    assert stops[0]["name"] == "Gjorche Petrov"
    assert stops[-1]["name"] == "Novo Lisice"

    reverse = await client.get(f"/api/v1/routes/{LINE_2}/stops", params={"direction_id": 1})
    assert [s["id"] for s in reverse.json()] == [s["id"] for s in reversed(stops)]


async def test_route_patterns_and_explicit_selection(client: AsyncClient) -> None:
    response = await client.get(f"/api/v1/routes/{LINE_2}/patterns")
    assert response.status_code == 200
    patterns = response.json()
    assert len(patterns) == 2
    assert {pattern["direction_id"] for pattern in patterns} == {0, 1}
    assert all(pattern["stop_count"] == 13 for pattern in patterns)
    assert all(pattern["trip_count"] > 0 for pattern in patterns)
    assert all(pattern["shape_available"] is True for pattern in patterns)

    outbound = next(pattern for pattern in patterns if pattern["direction_id"] == 0)
    stops = await client.get(
        f"/api/v1/routes/{LINE_2}/stops", params={"pattern_id": outbound["id"]}
    )
    assert stops.status_code == 200
    assert stops.json()[0]["name"] == "Gjorche Petrov"

    mismatch = await client.get(
        f"/api/v1/routes/{LINE_2}/stops",
        params={"pattern_id": outbound["id"], "direction_id": 1},
    )
    assert mismatch.status_code == 422


async def test_route_shape_geojson(client: AsyncClient) -> None:
    response = await client.get(f"/api/v1/routes/{LINE_2}/shape")
    assert response.status_code == 200
    body = response.json()
    assert body["type"] == "LineString"
    # 13 stops + 12 offset midpoints
    assert len(body["coordinates"]) == 25
    lon, lat = body["coordinates"][0]
    assert 21 < lon < 22 and 41 < lat < 43, "GeoJSON must be [lon, lat]"


async def test_route_trips_on_weekday(client: AsyncClient) -> None:
    response = await client.get(
        f"/api/v1/routes/{LINE_2}/trips", params={"service_date": "2026-05-04"}
    )
    assert response.status_code == 200
    trips = response.json()
    # 52 per direction (06:00-23:00 every 20 min) + 1 night trip per direction
    assert len(trips) == 106
    night_starts = [t for t in trips if t["starts_at"] == "23:45:00"]
    assert len(night_starts) == 2
    assert any(t["ends_at"] > "24:00:00" for t in night_starts)


async def test_route_trips_on_holiday_use_weekend_service(client: AsyncClient) -> None:
    holiday = await client.get(
        f"/api/v1/routes/{LINE_2}/trips", params={"service_date": "2026-09-08"}
    )
    # weekend timetable: 07:00-22:00 every 30 min = 31 per direction
    assert len(holiday.json()) == 62
