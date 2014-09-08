from os.path import join, dirname, abspath
from bottle import response, run, get, debug, static_file

app_path = abspath( join( dirname(__file__), '..' ) )
 #www_path = join(app_path, 'www')

@get('/')
def index():
    return static_file("index.html", root=app_path)


@get('/<filename:path>')
def static(filename):
    return static_file(filename, root=app_path)

run(host='localhost', port=8082, debug=True, reloader=True)
