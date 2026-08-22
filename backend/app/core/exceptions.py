"""Domain exceptions, mapped to HTTP responses in app.main (keeps HTTP concerns
out of services and repositories)."""


class NotFoundError(Exception):
    """Requested entity does not exist."""

    def __init__(self, entity: str, key: object):
        self.entity = entity
        self.key = key
        super().__init__(f"{entity} {key} not found")


class InvalidRequestError(Exception):
    """A validly-shaped request contains incompatible domain selectors."""
