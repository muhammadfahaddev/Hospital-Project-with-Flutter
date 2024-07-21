from graphviz import Digraph

# Create a new directed graph
dot = Digraph(comment='PDA Transition Table')

# Define the columns for the table
columns = ['Current State', 'Input Symbol', 'Stack Top', 'Stack Operation (Push)', 'Next State']

# Define the transitions
transitions = [
    ('q0', 'wr', 'Z', 'Z', 'q0'),
    ('q0', 'wr', 'C', 'ε', 'q0'),
    ('q0', 'ne', 'Z', 'Z', 'q0'),
    ('q0', 'ne', 'C', 'C', 'q1'),
    ('q1', 'cr', 'Z', 'CZ', 'q1'),
    ('q1', 'wr', 'C', 'ε', 'q0'),
    ('q1', 'ne', 'C', 'C', 'q2'),
    ('q2', 'cr', 'C', 'CC', 'q2'),
    ('q2', 'wr', 'C', 'ε', 'q0'),
    ('q2', 'ne', 'C', 'C', 'q3'),
    ('q3', 'cr', 'C', 'CC', 'q3'),
    ('q3', 'wr', 'C', 'ε', 'q0'),
    ('q3', 'ne', 'C', 'C', 'q4'),
    ('q4', 'cr', 'C', 'CC', 'q4'),
    ('q4', 'wr', 'C', 'ε', 'q0'),
    ('q4', 'ne', 'C', 'C', 'q5'),
    ('q5', 'cr', 'C', 'CC', 'q5'),
    ('q5', 'wr', 'C', 'ε', 'q0'),
    ('q5', 'ne', 'C', 'C', 'q6'),
    ('q6', 'cr', 'C', 'CC', 'q6'),
    ('q6', 'wr', 'C', 'ε', 'q0'),
    ('q6', 'ne', 'C', 'C', 'q7'),
    ('q7', 'cr', 'C', 'CC', 'q7'),
    ('q7', 'wr', 'C', 'ε', 'q0'),
    ('q7', 'ne', 'C', 'C', 'q8'),
    ('q8', 'cr', 'C', 'CC', 'q8'),
    ('q8', 'wr', 'C', 'ε', 'q0'),
    ('q8', 'ne', 'C', 'C', 'q8')
]

# Start constructing the HTML-like table
table_label = f"""<
<TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0">
  <TR>
    <TD><B>{columns[0]}</B></TD>
    <TD><B>{columns[1]}</B></TD>
    <TD><B>{columns[2]}</B></TD>
    <TD><B>{columns[3]}</B></TD>
    <TD><B>{columns[4]}</B></TD>
  </TR>"""

for transition in transitions:
    table_label += f"""
  <TR>
    <TD>{transition[0]}</TD>
    <TD>{transition[1]}</TD>
    <TD>{transition[2]}</TD>
    <TD>{transition[3]}</TD>
    <TD>{transition[4]}</TD>
  </TR>"""

table_label += "</TABLE>>"

# Add the table node
dot.node('table', table_label, shape='plaintext')

# Render and save the table as an image
dot.render('pda_transition_table', format='png', cleanup=True)
