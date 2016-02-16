Todo
- line
  - [x] interpolators
  - [ ] defined
  - [ ] tension
  - [x] scale
  - [ ] style
- area  
  - [x] interpolators
  - [ ] defined
  - [ ] tension
  - [ ] x0?
  - [x] scale
  - [ ] style
- axis
  - [ ] style
  - [ ] orientation
  - [ ] ticks
  - [ ] tick values
  - [ ] tick size
  - [ ] inner tick size
  - [ ] outer tick size
  - [ ] tick padding  
  - [ ] tick format  
- scale
  - [x] identity
  - [x] linear-closed
  - [ ] ordinal
  - [ ] power
  - [ ] log
  - [ ] quantize
  - [ ] quantile
  - [ ] threshold
  - [ ] time
- interpolators
  - [x] linear
  - [ ] linear-closed
  - [ ] step
  - [ ] step-before
  - [ ] step-after
  - [ ] basis
  - [ ] basis-open
  - [ ] basis-closed
  - [ ] bundle
  - [ ] cardinal
  - [ ] cardinal-open
  - [ ] cardinal-closed
  - [ ] monotone
- [ ] append additional html to plot (titles, etc)
- [x] append svg at a point (plot something other than points)
- bar?
- record pattern matching in a list


for our plots
- panning and zooming
- mouse input

- [x] PQR tile
- [ ] PQR/Peak Mod scope
  - axises with labels and ticks
  - pan and zooming
  - mouse input for point selection
- [ ] QC Cal tile / scope
  - axises with labels and ticks
  - append svg at point
- [ ] batch summary chart
  - ordinal scale
  - axises with labels and ticks



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
