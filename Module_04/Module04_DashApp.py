
# import these packages.
import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_table

from dash.dependencies import Input, Output

import pandas as pd
import numpy as np

import plotly.express as px

# Using external stylesheet for htlp formating. 
external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']


# Generating Data as required by the two questions:
# Question 1:
soql_url_1 = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=health,count(tree_id)' +\
        '&$group=health').replace(' ', '%20')

soql_trees_1 = pd.read_json(soql_url_1)
soql_trees_1.dropna(inplace=True)
soql_trees_1.columns = ["Health","Count"]

fig_1 = px.pie(soql_trees_1, values='Count', names='Health')


# Question 2:
soql_url_2 = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=steward,health,count(tree_id)' +\
        '&$group=steward,health').replace(' ', '%20')

soql_trees_2 = pd.read_json(soql_url_2)
soql_trees_2.dropna(inplace=True)
soql_trees_2.columns = ["Stewards","Health","Count"]

fig_2 = px.bar(
    data_frame=soql_trees_2,
    x="Stewards",
    y="Count",
    color="Health",
    barmode="group",
)


# Initialise the app
app = dash.Dash(__name__, external_stylesheets=external_stylesheets)


# Define the app
app.layout = html.Div([
    html.H1(children="New York City Tree Census",),
    html.P(children="In this module we’ll be looking at data from the New York City tree census:",),
    html.P(children="https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh",),
    html.P(children="This data is collected by volunteers across the city, and is meant to catalog information about every single tree in the city.",),
    html.P(children="A dash app for an arborist studying the health of various tree species.",),
    dcc.Tabs(id='tabs-example', value='tab-1', children=[
        dcc.Tab(label='Question 1: Health Of Trees', value='tab-1'),
        dcc.Tab(label='Question 2: Stewards Impact', value='tab-2'),
    ]),
    html.Div(id='tabs-example-content')
])


# App Callback 
@app.callback(Output('tabs-example-content', 'children'),
              Input('tabs-example', 'value'))
def render_content(tab):
    if tab == 'tab-1':
        return html.Div(
		    children=[
		        html.H5(children="1. What proportion of trees are in good, fair, or poor health according to the ‘health’ variable?",),
			    html.Div([
			        html.Div([
			            html.P('Data Table'),
			            dash_table.DataTable(
						    id='table',
						    columns=[{"name": i, "id": i} for i in soql_trees_1.columns],
						    data=soql_trees_1.to_dict('records'),
						)
			        ], className="six columns"),

			        html.Div([
			            html.P('Pie Chart'),
			            dcc.Graph(figure=fig_1)
			        ], className="six columns"),
			    ], className="row")
		    ]
		)
    elif tab == 'tab-2':
        return html.Div(
		    children=[
		        html.H5(children="2. Are stewards (steward activity measured by the ‘steward’ variable) having an impact on the health of trees?",),
			    html.Div([
			        html.Div([
			            html.P('Data Table'),
			            dash_table.DataTable(
						    id='table',
						    columns=[{"name": i, "id": i} for i in soql_trees_2.columns],
						    data=soql_trees_2.to_dict('records'),
						)
			        ], className="six columns"),

			        html.Div([
			            html.P('Bar Chart'),
			            dcc.Graph(figure=fig_2)
			        ], className="six columns"),
			    ], className="row")
		    ]
		)


# Run the app
if __name__ == '__main__':
    app.run_server(debug=True)
