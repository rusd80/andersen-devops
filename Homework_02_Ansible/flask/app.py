from flask import Flask, render_template

app = Flask(__name__)


@app.route("/help")
def help_page():
    return "<b><font color=green>This is Help Page!</font></b>"


@app.route("/about")
def about_page():
    return "<b><font color=blue>This is a training project</font></b>"


@app.route("/")
def index():
    title = 'Devops courses'
    user = {'nickname': 'student'}
    return render_template("index.html",
                           title=title,
                           user=user)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

# setuptools~=59.2.0