import os
import dash
from dash import html

app = dash.Dash(__name__)
server = app.server  # for gunicorn
app.layout = html.Div([
    html.H1("Hello from Dash!")
])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8050)))