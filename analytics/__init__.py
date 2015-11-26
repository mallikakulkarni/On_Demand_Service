from Flask import Flask

from settings import *


app = Flask(__name__)
app.config["MONGODB_SETTINGS"] = MONGODB_SETTINGS
app.config["SECRET_KEY"] = SECRET_KEY



if __name__ == '__main__':
    app.run()