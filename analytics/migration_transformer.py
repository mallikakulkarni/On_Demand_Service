import datetime

from pymongo.son_manipulator import SONManipulator


class MigrationTransformer(SONManipulator):

    def _encode_date(self, value):
        return datetime.datetime.combine(
                value,
                datetime.datetime.min.time())

    def transform_incoming(self, son, collection):
        for (key, value) in son.items():
            # datetime.datetime is instance of datetime.date
            # compare type explicitly only
            if type(value) == datetime.date:
                son[key] = self._encode_date(value)
            elif isinstance(value, dict):    # recurse into sub-docs
                son[key] = self.transform_incoming(value, collection)
        return son

    def transform_outgoing(self, son, collection):
        for(key, value) in son.items():
            if type(value) == datetime.date:
                son[key] = self._encode_date(value)
            elif isinstance(value, dict):
                son[key] = self.transform_outgoing(value, collection)
        return son