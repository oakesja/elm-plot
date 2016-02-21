try to remove html dependency
append additional svg to plot
give option of width and height for range of scale
default padding
negative dimensions
negative margins
handle scales that don't need to change from margins

axis
  - scale - required but plot needs to adjust for margins somehow
  - orient - required
  - number of ticks or tick values - default none
  - inner tick size - default 6
  - outer tick size - default 6
  - padding (space between label and axis) - default 3
  - rotation (how much to rotate the label by) - default 0
  - style for axis - default [fill "none", stroke "#000", shapeRendering "crispEdges"]
  - style for inner ticks - default [fill "none", stroke "#000", shapeRendering "crispEdges"]
  - style for labels
  - tick format
  - grid lines - default none
  - grid line style - default none
  - title - default none
  - title offset

Design

1. Top level Properties
  - width
  - height
  - padding (top, left, right, bottom)
  - list of other styles to apply to top level svg

1. Data
  Can this be dynamic in some way? Or easily transformable? Ideally would not have to manipulate the data but framework would provide some way of selecting what parts of the data to use. Right now data and visual elements are combined into one.

1. Scales
  - domain of data values
  - range of visual values
  - map a value in the domain to a visual value

1. Axes
  Pretty much everything from https://github.com/vega/vega/wiki/Axes is useful.

1. Marks (Don't really like this name)
  Visual building blocks. Needs a value and a scale to know where to place it. Look into supporting life cycle events (enter, update, exit, hover) Currently this is tied together with the data. Would be nice to have a way of mapping to the data.  https://github.com/vega/vega/wiki/Marks

1. Signals
  User specify events that it wants to handle for marks. When that event occurs
  an action is sent to user to handle. If some type of UI changes need to be made
  then the user sends that action along with a function to transform the thing.
