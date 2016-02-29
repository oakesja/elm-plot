append additional svg to plot
give option of width and height for range of scale
negative dimensions
negative margins
handle scales that don't need to change from margins
padding for normal range and reverse range do not appear to be the same
arcs for pie charts
custom bands
change sets (domain and range) to be model instead of a tuple to clean up code in scales
be able to update domain and ranges for scale
consider adding panning and zooming as part of the framework, only makes sense for linear scales though
don't draw points outside of bounding box but how to handle lines and areas that cross bounding box
consider doing grid lines separate from axises to allow when to draw and how many ticks
adding events to an individual line or point

plot
  - [x] margins (most components will need to wait to be created until margins are known)
  - [ ] additional svg
  - [x] top level style

linear scales
  - [x] number of ticks
  - [ ] tick values instead of number of ticks

ordinal scales
  - [x] points
  - [x] bands
    - check case of only domain of length 1 or 2
    - check y axis and that horizontal bars
  - [ ] specified range
  - [ ] handle undefined points that are not in the domain

bars
  - [x] orient (horizonal or vertical)
  - [x] style

rules (are these actually useful?)
  - [ ] vertical y y2 x
  - [ ] horizontal x x2 y
  - [ ] additional attributes

symbols
  - [x] circle
  - [x] square
  - [ ] cross
  - [x] diamond
  - [x] triangle up
  - [x] triangle down
  - [x] custom

axis
  - [x] scale - required but plot needs to adjust for margins somehow
  - [x] orient - required
  - [x] inner tick size - default 6
  - [x] outer tick size - default 6
  - [x] padding (space between label and axis) - default 3
  - [x] rotation (how much to rotate the label by) - default 0
  - [x] style for axis - default [fill "none", stroke "#000", shapeRendering "crispEdges"]
  - [x] style for inner ticks - default [fill "none", stroke "#000", shapeRendering "crispEdges"]
  - [ ] style for labels - default depends on orientation
  - [ ] tick format
  - [ ] grid lines - default none
  - [ ] grid line style - default none
  - [x] title - default none
  - [x] title offset
  - [x] title style

examples
  - [ ] linear scale
  - [ ] each point type
  - [ ] custom point
  - [ ] ordinal scale point
  - [ ] ordinal scale bands
  - [ ] custom with ordinal scale bands (triangles going to axis from point with band width)
  - [ ] events  

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
