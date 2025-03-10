import uuid

from sqlalchemy import CHAR, TypeDecorator
from sqlalchemy.dialects.postgresql import UUID

from configs import dify_config

from .engine import db


class StringUUID(TypeDecorator):
    impl = CHAR
    cache_ok = True

    def process_bind_param(self, value, dialect):
        if value is None:
            return value
        elif dialect.name == "postgresql":
            return str(value)
        else:
            return value.hex

    def load_dialect_impl(self, dialect):
        if dialect.name == "postgresql":
            return dialect.type_descriptor(UUID())
        else:
            return dialect.type_descriptor(CHAR(36))

    def process_result_value(self, value, dialect):
        if value is None:
            return value
        return str(value)


def uuid_default():
    if dify_config.SQLALCHEMY_DATABASE_URI_SCHEME == "postgresql":
        return {"server_default": db.text("uuid_generate_v4()")}
    else:
        return {"default": lambda: uuid.uuid4()}


def varchar_default(varchar):
    if dify_config.SQLALCHEMY_DATABASE_URI_SCHEME == "postgresql":
        return {"server_default": db.text(f"'{varchar}'::character varying")}
    else:
        return {"default": varchar}


def text_default(varchar):
    if dify_config.SQLALCHEMY_DATABASE_URI_SCHEME == "postgresql":
        return {"server_default": db.text(f"'{varchar}'::text")}
    else:
        return {"default": varchar}
