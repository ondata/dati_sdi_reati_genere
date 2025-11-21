This file is a merged representation of a subset of the codebase, containing specifically included files, combined into a single document by Repomix.

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: guide/**/*.qmd
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
```
guide/
  aesthetic-mappings.qmd
  aesthetic-specification.qmd
  annotations.qmd
  case-study1.qmd
  case-study2.qmd
  case-study3.qmd
  coordinate-systems.qmd
  export.qmd
  facets.qmd
  feature-coverage.qmd
  geom-cheatsheet.qmd
  geometric-objects.qmd
  install.qmd
  introduction.qmd
  labels.qmd
  maps.qmd
  misc.qmd
  operators.qmd
  overview.qmd
  plot-composition.qmd
  position-adjustments.qmd
  scale-basics.qmd
  scale-breaks-labels.qmd
  scale-color-fill.qmd
  scale-misc.qmd
  scale-x-and-y.qmd
  shortcuts.qmd
  themes-basics.qmd
  themes-custom.qmd
  themes-premade.qmd
```

# Files

## File: guide/aesthetic-mappings.qmd
````
---
title: Aesthetic mappings
jupyter: python3
execute:
  # disable warnings for missing values in penguins dataset
  warning: false
---

The `aes()` function maps columns of data onto graphical attributes--such as colors, shapes, or x and y coordinates. (`aes()` is short for aesthetic). It can be specified at the plot level, as well as at the individual geom level.

This page will cover the basics of specifying mappings and how they interact with geoms.


:::{.callout-tip title="You will learn"}
* How to map data to aesthetic attributes with `aes()`.
* How to set a literal mapping, like coloring all points red.
* How the `aes(group=...)` argument works.
:::

:::{.callout-note title="Key points" collapse="true"}

* `aes()` maps variables (columns) to chart dimensions (e.g. x, y, or color).
* Variable mappings in `aes()` can be simple names or expressions (e.g. `"somecol / 10"`).
* Literal mappings can be passed directly to geoms (e.g. hard-code color to "red").
* `aes()` can be used in the initial `ggplot()` call, or inside specific `geoms()`.
* Mapping `aes(group=...)` can be used to make multiple trend lines per group.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import penguins
```



## Basics

The simplest way to specify aesthetic mappings is through passing `aes()` to the `ggplot(mapping = ...)` argument. This is shown below, with `flipper_length_mm` and `body_mass_g` mapped to the x- and y- axes.

```{python}
(
    ggplot(
      data=penguins,
      mapping=aes(x="flipper_length_mm", y="body_mass_g")
    )
    + geom_point()
)
```

## Variable mappings

When a mapping in `aes()` references a column of data, it is called a variable mapping---since the values of the column are used to determine the appearance of the plot. Below are some plots with variable mappings to different columns of data (e.g `flipper_length_mm`, `body_mass_g`, `species`).

::: {.panel-tabset}

### Color

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g", color="species")
    )
    + geom_point()
)

```

### Shape

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g", shape="species"),
    )
    + geom_point()
)
```

### Size and alpha

```{python}
(
    ggplot(
        penguins,
        aes(
            x="flipper_length_mm",
            y="body_mass_g",
            size="body_mass_g",
            alpha="body_mass_g",
        ),
    )
    + geom_point()
)
```

:::

## Literal mappings

In order to set a mapping to a literal value, pass the value directly to the geom. For example, the code below sets `size=`, `alpha=`, and `color=` to specific values.

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g"),
    )
    + geom_point(size=7, alpha=.5, color="purple")
)
```

## `aes()` inside a specific geom

An `aes()` mapping can be applied to a single geom, by passing it directly to the geom call. For example, the code below sets color for one point, and shape for another.

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g"),
    )
    + geom_point(aes(color="species"), size=5)   # big circle points
    + geom_point(aes(shape="species"))           # shape points
)
```

## `aes()` collective groupings

Some geoms accept a `aes(group=...)`. These are called [collective geoms](./geometric-objects.qmd#kinds-of-geoms), because they group data points together. For example, `geom_smooth()` fits a trend line to the data, and the group mapping tells it to create a separate line per grouping in the data.

This is shown below, with a trend line created for each of the three `species` of penguins.

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g", group="species"),
    )
    + geom_point()
    + geom_smooth(method="lm")
)
```

### Automatic groupings

Mappings attributes like `color` will automatically group data points for collective geoms, even if `group` isn't specified.

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g", color="species"),
    )
    + geom_point()
    + geom_smooth(method="lm")
)
```

### Working around grouping

To avoid automatically splitting data into groups, try setting aesthetics like `color` or `fill` at the individual geom level.

For example, the plot below colors points by `species`, but with only a single trend line.

```{python}
(
    ggplot(
        penguins,
        aes(x="flipper_length_mm", y="body_mass_g"),
    )
    + geom_point(aes(color="species"))
    + geom_smooth(method="lm")
)
```

## Mappings allow expressions

Mappings passed to `aes()` can be expression strings.

For example, you could make a scatterplot with `bill_length_mm / bill_depth_mm` on the x-axis as follows.


```{python}
(
    ggplot(
        penguins,
        aes(x="bill_length_mm / bill_depth_mm", y="body_mass_g"),
    )
    + geom_point(aes(color="species"))
)
```
````

## File: guide/aesthetic-specification.qmd
````
---
title: Aesthetic specifications
jupyter: python3
ipynb-shell-interactivity: all
---

This document is a translation of the [ggplot2 aesthetic specification](https://ggplot2.tidyverse.org/articles/ggplot2-specs.html).

```{python}
import pandas as pd
from plotnine import *
```

## Color and fill

Almost every geom has either color, fill, or both. Colors and fills can be specified in the following ways:

* A **name**, e.g., `"red"`. These can be any color name or value supported by matplotlib. See the [matplotlib css colors documentation](https://matplotlib.org/stable/gallery/color/named_colors.html#css-colors) and the plot below for a list of colors.
* An __rgb specification__, with a string of the form `"#RRGGBB"` where each of 
    the pairs `RR`, `GG`, `BB` consists of two hexadecimal digits giving a value 
    in the range `00` to `FF`

    You can optionally make the color transparent by using the form 
    `"#RRGGBBAA"`.
* A missing value (e.g. None, np.nan, pd.NA), for a completely transparent colour. 

Here's an example of listing CSS color names matplotlib supports:

```{python}
from matplotlib import colors as mcolors

n_colors = len(mcolors.CSS4_COLORS)
colors = pd.DataFrame(
    {
        "name": [name for name in mcolors.CSS4_COLORS.keys()],
        "x": [(x // 30) * 1.5 for x in range(n_colors)],
        "y": [-(x % 30) for x in range(n_colors)],
    }
)

(
    ggplot(colors, aes("x", "y"))
    + geom_point(aes(color="name"), size=5)
    + geom_text(aes(label="name"), nudge_x=0.14, size=7.5, ha="left")
    + scale_color_identity(guide=None)
    + expand_limits(x=7)
    + theme_void()
    + labs(title="CSS4 colors")
)
```


## Lines

As well as `colour`, the appearance of a line is affected by `linewidth`, `linetype`, `linejoin` and `lineend`.

### Line type {#sec:line-type-spec}

Line types can be specified with:

*   A __name__: solid, dashed, dotted, 
    dashdot, as shown below:
    
    ```{python}
    #| fig-alt: "A series of 6 horizontal lines with different line types.
    #|  From top-to-bottom they are titled 'solid', 'dashed', 'dotted',
    #|  'dotdash', 'longdash', 'twodash'."
    lty = [
        "solid",
        "dashed",
        "dotted",
        "dashdot",
        ]
    linetypes = pd.DataFrame({
      "y": list(range(len(lty))),
      "lty": lty
    }) 

    (
        ggplot(linetypes, aes(0, "y"))
        + geom_segment(aes(xend=5, yend="y", linetype="lty"))
        + geom_text(aes(label="lty"), nudge_y=0.2, ha="left")
        + scale_x_continuous(name=None, breaks=None)
        + scale_y_reverse(name=None, breaks=None)
        + scale_linetype_identity(guide=None)

    )
    ```

*   The lengths of on/off stretches of line. This is done with a tuple of the form `(offset, (on, off, ...))`. 

    ```{python}
    # | fig-alt:
    # |   A series of 9 horizontal lines with different line types.
    # |   Each line is titled by two hexadecimal digits that determined the
    # |   lengths of dashes and gaps."
    lty = [
        (0, (1, 1)),
        (0, (1, 8)),
        (0, (1, 15)),
        (0, (8, 1)),
        (0, (8, 8)),
        (0, (8, 15)),
        (0, (15, 1)),
        (0, (15, 8)),
        (0, (15, 15)),
        (0, (2, 2, 6, 2)),
    ]
    linetypes = pd.DataFrame({"y": list(range(len(lty))), "lty": lty})
    
    (
        ggplot(linetypes, aes(0, "y"))
        + geom_segment(aes(xend=5, yend="y", linetype="lty"))
        + geom_text(aes(label="lty"), nudge_y=0.2, ha="left")
        + scale_x_continuous(name=None, breaks=None)
        + scale_y_reverse(name=None, breaks=None)
        + scale_linetype_identity(guide=None)
    )
    ```


The three standard dash-dot line types described above correspond to:

* dashed: `(0, (4, 4))`
* dotted: `(0, (1, 3)`
* dashdot: `(0, (1, 3, 4, 3))`

### Linewidth


Due to a historical error, the unit of linewidth is roughly 0.75 mm. Making it 
exactly 1 mm would change a very large number of existing plots, so we're stuck 
with this mistake.

### Line end/join parameters

*   The appearance of the line end is controlled by the `lineend` paramter,
    and can be one of "round", "butt" (the default), or "square".

    ```{python}
    #| fig-alt: [
    #| "A plot showing a line with an angle. A thinner red line is placed over
    #|  a thicker black line. The black line ends where the red line ends.",
    #| "A plot showing a line with an angle. A thinner red line is placed over
    #|  a thicker black line. The black line ends past where the red line ends,
    #|  and ends in a semicircle.",
    #| "A plot showing a line with an angle. A thinner red line is placed over
    #|  a thicker black line. The black line ends past where the red line ends,
    #|  and ends in a square shape."
    #| ]
    #| layout-nrow: 1
    df = pd.DataFrame({"x": [1,2,3], "y": [4, 1, 9]})
    base = ggplot(df, aes("x", "y")) + xlim(0.5, 3.5) + ylim(0, 10)
    (
        base
        + geom_path(size=10)
        + geom_path(size=1, colour="red")
    )
    
    (
        base
        + geom_path(size=10, lineend="round")
        + geom_path(size=1, colour="red")
    )
    
    (
        base
        + geom_path(size=10, lineend="square")
        + geom_path(size=1, colour="red")
    )
    ```

*   The appearance of line joins is controlled by `linejoin` and can be one of 
    "round" (the default), "mitre", or "bevel".

    ```{python}
    #| layout-nrow: 1
    #| fig-alt: [
    #|   "A plot showing a thin red line on top of a thick black line shaped like   the letter 'V'. The corner in the black V-shape is rounded.",
    #|   "A plot showing a thin red line on top of a thick black line shaped like the letter 'V'. The corner in the black V-shape is sharp.",
    #|   "A plot showing a thin red line on top of a thick black line shaped like the letter 'V'. A piece of the corner is cut off so that the two straight parts are connected by a horizontal part."
    #| ]
    df = pd.DataFrame({"x": [1,2,3], "y": [9, 1, 9]})
    base = ggplot(df, aes("x", "y")) + ylim(0, 10)
    (
        base
        + geom_path(size=10)
        + geom_path(size=1, colour="red")
    )
    

    (
        base
        + geom_path(size=10, linejoin="mitre")
        + geom_path(size=1, colour="red")
    )
    
    (
        base
        + geom_path(size=10, linejoin="bevel")
        + geom_path(size=1, colour="red")
    )
    ```

Mitre joins are automatically converted to bevel joins whenever the angle is too small (which would create a very long bevel). This is controlled by the `linemitre` parameter which specifies the maximum ratio between the line width and the length of the mitre.


## Polygons

The border of the polygon is controlled by the `colour`, `linetype`, and `linewidth` aesthetics as described above. The inside is controlled by `fill`.

## Point

### Shape {#sec:shape-spec}

<!--
TODO: Document all ways of specifying shapes.
Shapes take five types of values:
*   A character string or an integer for a point type, as specified in [matplotlib.markers](https://matplotlib.org/stable/api/markers_api.html#):
-->

* A character string or an integer for a point type, as specified in [matplotlib.markers](https://matplotlib.org/stable/api/markers_api.html#):


  ```{python}
  from plotnine.scales.scale_shape import shapes, unfilled_shapes
  
  shape_points = [*shapes, *unfilled_shapes, "none"]
  
  n_shapes = len(shape_points)
  shapes = pd.DataFrame(
      {
          "shape": shape_points,
          "shape_text": [repr(x) if str(x).isdigit() else x for x in shape_points],
          "x": [x % 5 for x in range(n_shapes)],
          "y": [-(x // 5) for x in range(n_shapes)],
      }
  )
  
  (
      ggplot(shapes, aes("x", "y"))
      + geom_point(aes(shape="shape"), size=5, fill="red")
      + geom_text(aes(label="shape_text"), nudge_x=0.15)
      + scale_shape_identity(guide=None)
      + theme_void()
      + expand_limits(x=4.1)
  )
  ```
  
* Shape path and mathtex (specified in the bottom of [matplotlib.markers](https://matplotlib.org/stable/api/markers_api.html#) table):
  
  ```{python}
  # (num, type, angle)
  pentagon = (5, 0, 60)             # type 0: polygon
  five_point_star = (5, 1, 60)      # type 1: star
  five_point_asterisk = (5, 2, 60)  # type 2: asterisk
  
  shape = [pentagon, five_point_star, five_point_asterisk, "$\\alpha$", "$\\beta$"]
  shape_text = [x.replace("$", "\\$") if isinstance(x, str) else x for x in shape]
  
  shapes = pd.DataFrame(
      {
          "shape": shape,
          "shape_text": shape_text,
          "x": list(range(len(shape))),
          "y": [0] * len(shape),
      }
  )
  
  (
      ggplot(shapes, aes("x", "y"))
      + geom_point(aes(shape="shape"), size=10)
      + geom_text(aes(label="shape_text"), nudge_y=-0.1)
      + scale_shape_identity(guide=None)
      + theme_void()
      #+ theme(figure_size=(6, 2))
      + expand_limits(y=[-0.2, 0.2], x=[-0.5, len(shape) - 0.5])
  )
  ```

* Custom matplotlib [path objects](https://matplotlib.org/stable/api/path_api.html#matplotlib.path.Path) as a literal mapping:
  
  ```{python}
  from plotnine.data import mtcars
  from matplotlib.path import Path
  
  
  star = Path.unit_regular_star(6)
  circle = Path.unit_circle()
  
  cut_star = Path(
      vertices=[*circle.vertices, *star.vertices[::-1]],
      codes=[*circle.codes, *star.codes]
  )
  
  (
      ggplot(mtcars, aes("wt", "mpg"))
      + geom_point(shape=cut_star, size=10)
  )
  ```

### Color and fill

While `color` applies to all shapes, `fill` only applies to shapes with red fill in the plot above. The size of the filled part is controlled by `size`, the size of the stroke is controlled by `stroke`. Each is measured in mm, and the total size of the point is the sum of the two. Note that the size is constant along the diagonal in the following figure.

```{python}
# | fig-alt: "A plot showing a 4-by-4 grid of red points, the top 12 points with
# |  black outlines. The size of the points increases horizontally. The stroke of
# |  the outlines of the points increases vertically. A white diagonal line with
# |  a negative slope marks that the 'stroke' versus 'size' trade-off has
# |  similar total sizes."
sizes = pd.DataFrame({"size": [0, 2, 4, 6]}).merge(
    pd.DataFrame({"stroke": [0, 2, 4, 6]}), how="cross"
)

(
    ggplot(sizes, aes("size", "stroke", size="size", stroke="stroke"))
    + geom_abline(slope=-1, intercept=6, colour="white", size=6)
    + geom_point(shape="o", fill="red")
    + scale_size_identity(guide=None)
)
```



## Text

### Font family

There are only three fonts that are guaranteed to work everywhere: "sans" (the default), "serif", or "mono":

```{python}
# | fig-alt: "A plot showing three text labels arranged vertically. The top
# |  label is 'sans' and is displayed in a sans-serif font. The middle label is
# |  'serif' and is displayed in a serif font. The bottom label is 'mono' and
# |  is displayed in a monospaced font."


df = pd.DataFrame(
    {"x": 1, "y": [3, 2, 1], "family": ["sans-serif", "serif", "monospace"]}
)

(ggplot(df, aes("x", "y")) + geom_text(aes(label="family", family="family"), size=20))
```


### Font weight

There are two important considerations when using font weights:

* font family must support your intended font weight(s).
* fonts that bundle their multiple variants in one `.ttc` file may currently not be supported on your platform. (see [this issue](https://github.com/has2k1/plotnine/issues/941))

```{python}
# | fig-alt: "A plot showing four text labels arranged vertically. Top to bottom
# |  the labels are 'heavy', 'bold', 'normal' and 'light' and are displayed in
# |  in their respective styles as supported by the font."
df = pd.DataFrame(
    {"x": [1, 2, 3, 4], "fontweight": ["light", "normal", "bold", "heavy"]}
)

(
    ggplot(df, aes(1, "x"))
    + geom_text(
        aes(label="fontweight", fontweight="fontweight"),
        family="Dejavu Sans",
    )
)
```

### Font style

Similar to font weight, fonts that bundle multiple variants in one `.ttc` may not be supported (see [this issue](https://github.com/has2k1/plotnine/issues/941))

```{python}
df = pd.DataFrame({"x": [1, 2, 3], "fontstyle": ["normal", "italic", "oblique"]})

(
    ggplot(df, aes(1, "x"))
    + geom_text(
        aes(label="fontstyle", fontstyle="fontstyle"),
        family="DejaVu Sans",
    )
)
```


### Font size

The `size` of text is measured in mm by default. This is unusual, but makes the size of text consistent with the size of lines and points. Typically you specify font size using points (or pt for short), where 1 pt = 0.35mm. In `geom_text()` and `geom_label()`, you can set `size.unit = "pt"` to use points instead of millimeters. In addition,
ggplot2 provides a conversion factor as the variable `.pt`, so if you want to draw 12pt text, you can also set `size = 12 / .pt`.

### Justification

Horizontal and vertical justification have the same parameterisation, either a string ("top", "middle", "bottom", "left", "center", "right") or a number between 0 and 1:

* top = 1, middle = 0.5, bottom = 0
* left = 0, center = 0.5, right = 1

```{python}
#| fig-alt: "A 3-by-3 grid of text on top of points, with horizontal text
#|  justification increasing from 0 to 1 on the x-axis and vertical 
#|  justification increasing from 0 to 1 on the y-axis. The points make it
#|  easier to see the relative placement of text."
just = pd.DataFrame({"hjust": ["center", "right", "left"], "x": [0, 1, 2]}).merge(pd.DataFrame({"vjust": ["center", "top", "bottom"], "y": [0, 1, 2]}), how="cross")

just["label"] = just["hjust"].astype(str).str.cat(just["vjust"].astype(str), sep=", ")

(
  ggplot(just, aes("x", "y"))
  + geom_point(colour="grey", size=5)
  + geom_text(aes(label="label", hjust="hjust", vjust="vjust"))
  + expand_limits(x=[-.5, 2.5], y=[-.5, 2.5])
)
```

Note that you can use numbers outside the range (0, 1), but it's not recommended.
````

## File: guide/annotations.qmd
````
---
title: Annotations
jupyter: python3
---

This page covers how to describe or emphasize data with annotations in plots. This includes labelling points, adding arrows, and highlighting areas of interest. It also describes how to tackle the common issue of overlapping text labels.

:::{.callout-tip title="You will learn"}
* How to quickly draw a single geom, without having to pass in data.
* How to add more complex styling to `geom_text()`.
* How to avoid overlapping text labels.
* How to emphasize areas of interest with boxes, arrows, and shading.
:::

:::{.callout-note title="Key points" collapse="true"}
* Use `annotate()` to quickly add a single geom mark to a plot.
* Use `geom_text(path_effects=...)` to add more complex styling to text labels.
* Use `geom_text(adjust_text=...)` to automatically adjust the position of text labels so they don't overlap.
* More advanced styling of text labels (e.g. in the plot title), requires manually handling matplotlib objects.
* Use `geom_rect()` to add background shading to plots.
* Use `geom_segment()` to add arrows to plots.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import penguins
```

## `annotate()`

Use `annotate()` to write some text on a plot.

```{python}
#| warning: false
r_coef = penguins["flipper_length_mm"].corr(penguins["body_mass_g"])
p = (
    ggplot(penguins, aes("flipper_length_mm", "body_mass_g"))
    + geom_point()
    + geom_smooth(method="lm")
    + annotate(
        "text",
        x=180,
        y=5750,
        label=f"r = {r_coef:.2f}",
        color="blue",
        size=20,
    )
)

p
```

Notice that the correlation coefficient is shown on the top-left of the plot. The first argument to annotate, specifies the geom to use (in this case, the `"text"` means to use `geom_text()`).

In order to use annotate with another geom, pass the name of the geom as the first argument. For example, the code below draws a rectangle around the text.

```{python}
#| warning: false
p + annotate("rect", xmin=170, xmax=190, ymin=5500, ymax=6000, color="blue", fill=None)
```

Note that `annotate()` takes the same arguments as the corresponding `geom_*()` class (in this case, `geom_rect()`).

## `geom_text(path_effects=...)`

Use the `geom_text(path_effects=...)` argument to add more complex styling to your text. This argument takes a list of objects created by the `matplotlib.patheffects` submodule.

```{python}
#| warning: false
import matplotlib.patheffects as pe

effect = [
    pe.PathPatchEffect(offset=(4, -4), hatch="xxxx", facecolor="gray"),
    pe.PathPatchEffect(edgecolor="white", linewidth=1.1, facecolor="black"),
]

(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g"))
    + geom_point()
    + annotate("text", x=180, y=5750, label="YO", path_effects=effect, size=75)
)
```

## `geom_text(adjust_text=...)`

Use the `geom_text(adjust_text=...)` argument to adjust the position of text labels so they don't overlap. This argument takes a dictionary that gets passed to the `adjustText` package's `adjust_text()` function.

```{python}
from plotnine.data import mpg

(
    ggplot(mpg.drop_duplicates("model"), aes("displ", "hwy", label="model"))
    + geom_point()
    + geom_text(adjust_text={"arrowprops": {"arrowstyle": "-"}})
)
```

## Styling text

Currently, styling text requires manually handling matplotlib objects (which plotnine builds on top of). See the blogpost ["Annotated area charts with plotnine"](https://nrennie.rbind.io/blog/plotnine-annotated-area-chart/) for a walkthrough of creating custom text.


## Emphasis with shading


```{python}
import math
import pandas as pd
from plotnine.data import huron

droughts = pd.DataFrame(
    {
        "start": [1930, 1960],
        "stop": [1937, 1967],
    }
)

(
    ggplot(huron)
    + geom_line(aes("year", "level"))
    + geom_rect(
        aes(xmin="start", xmax="stop"),
        ymin=-math.inf,
        ymax=math.inf,
        alpha=0.2,
        fill="red",
        data=droughts,
    )
    + labs(
        title="Lake Huron Water Levels",
        subtitle="(famous droughts marked in red)",
    )
)
```

## Emphasis with arrows


```{python}
from plotnine.data import economics

(
    ggplot(economics, aes("date", "unemploy"))
    + geom_line()
    + scale_x_date(breaks="10 years")
    + annotate(
        "segment",
        x="2004-01-01",
        y=13000,
        xend="2007-01-01",
        yend=7600,
        color="red",
        arrow=arrow(length=0.2),
    )
    + annotate(
        "text",
        x="2004-01-01",
        y=13000,
        label="Great Recession",
        color="red",
        size=20,
        ha="right",
        nudge_x=-100,
    )
)
```
````

## File: guide/case-study1.qmd
````
---
title: Case study 1
---

Something similar to https://github.com/machow/coffee-sales-data, designed to show something compelling, that is a good intro to using plotnine.
````

## File: guide/case-study2.qmd
````
---
title: Case study 2
---

Something similar to https://github.com/machow/coffee-sales-data, designed to show something compelling, that is a good intro to some facet of using plotnine.
````

## File: guide/case-study3.qmd
````
---
title: Case study 3
---

Something similar to https://github.com/machow/coffee-sales-data, designed to show something compelling, that is a good intro to some facet of using plotnine.
````

## File: guide/coordinate-systems.qmd
````
---
title: Coordinate systems
jupyter: python3
---

Coordinate systems determine how the x- and y-axes of a plot are drawn.
For example, `coord_flip()` switches the x- and y-axes, while `coord_fixed()` ensures they have the same spacing.

:::{.callout-tip title="You will learn"}
* What coordinate systems are common for plots.
* How to flip and fix axes.
* The difference between scale and coordinate systems limits.
:::

:::{.callout-note title="Key points" collapse="true"}
* Common coordinate systems include cartesian and polar.
* Use `coord_flip()` to switch the x- and y-axes.
* Use `coord_fixed()` to ensure the x- and y-axes have the same spacing.
* Limits at the coordinate level zoom in or out, while limits at the scale level remove data.
* Maps currently use `geom_map()`, but will later have a `coord_map()`.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import diamonds, mpg
```

## coord_flip()

Use `coord_flip()` to switch the x- and y-axes of your plot.

```{python}
#| layout-nrow: 1

p = ggplot(diamonds, aes("cut")) + geom_bar()

p
p + coord_flip()
```

Notice that cut is the x-axis on the default plot (left), but the y-axis of the flipped one (right). This can be helpful for barplots with many individually labeled bars, since the labels won't overlap with eachother. It can also be useful for taking advantage of wider plots.

Flipped plots use the original axis names for setting titles and scales, but the final plot axis names for theme options.

```{python}
(
    ggplot(diamonds, aes("cut"))
    + geom_bar()
    + coord_flip()

    # labs and scales are based on original, non-flipped plot
    + labs(x="Diamond Cut", y="Count")
    + scale_y_continuous(breaks=[0, 10_000, 20_000])

    # theme options are based on the flipped plot
    + theme(axis_line_x=element_line(color="purple"))
)

```



## coord_cartesian()

Use `coord_cartesian()` to zoom in on a plot.

```{python}
#| layout-nrow: 1
p = ggplot(diamonds, aes("cut", "price")) + geom_boxplot()

p
p + coord_cartesian(ylim=[5000, None])
```

Notice that the second plot is zoomed in, so the y-axis starts at the top of the boxplots.  Importantly, `coord_cartesian()` doesn't affect any statistical calculations.

By contrast, [setting limits in scales](scale-basics.qmd#limits-for-restricting-data-range) excludes any data outside those limits.

```{python}
p + scale_y_continuous(limits=[5000, None])
```

Notice that in the plot above, `scale_y_continuous` excluded y-values under 5,000 from being used in calculating the boxplot.


## coord_fixed()

Use `coord_fixed()` to ensure the x- and y-axes have the same spacing.


```{python}
(
    ggplot(mpg, aes("cty", "hwy"))
    + coord_fixed(xlim=[0, None], ylim=[0,None])
    + geom_point()
)
```

## Cartographic maps

While currently not available as a coordinate system, Plotnine supports maps using `geom_map()`. In the future, maps will have a `coord_map()` function.

Here is an example which uses geopandas to plot grocery stores in Chicago.

```{python}
import geopandas as gp
import geodatasets

chicago = gp.read_file(geodatasets.get_path("geoda.chicago_commpop"))
groceries = gp.read_file(geodatasets.get_path("geoda.groceries"))

(
    ggplot(chicago)
    + geom_map(fill=None)
    + theme_void()
    + coord_fixed()
)
```

Notice that `coord_fixed()` was used to avoid stretching the map along the x- or y-axis. In addition, `theme_void()` removed the x- and y- tick marks, and labels.

You can plot multiple layers on the same map by using multiple `geom_map()` calls with different `data=` arguments.

```{python}
crs_groceries = groceries.to_crs(chicago.crs)

(
    ggplot()
    + geom_map(data=chicago, fill=None)
    + geom_map(data=crs_groceries, color="green")
    + theme_void()
    + coord_fixed()
)
```
````

## File: guide/export.qmd
````
---
title: Save and display
jupyter: python3
---

:::{.callout-tip title="You will learn"}
* How to display plots in Jupyter notebooks, Quarto documents, and the console.
* How to save plots to different formats.
* How to change plot size and resolution.
* How to ensure fonts in SVGs are self-contained.
:::

:::{.callout-note title="Key points" collapse="true"}
* Plots should display automatically in Jupyter and Quarto.
* Use the `.show()` method to explicitly display a plot (including while in the console).
* Use the `.save()` method to save a plot to a file.
* Plot size and resolution can be set in the `.save()` method, `theme()`, or globally.
* The `theme(svg_usefonts=False)` argument ensures fonts are self-contained in SVGs.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import penguins
```

## Displaying plots

By default, plots in Jupyter and Quarto should be displayed automatically.

For example, this website is built with Quarto, but the code below should also cause a plot to appear in a Jupyter notebook.

```{python}
#| warning: false
p = (
    ggplot(penguins, aes("bill_length_mm", "bill_depth_mm", color="species"))
    + geom_point()
    + labs(
        title="Palmer Penguins Bill Depth vs Length",
        x="Bill length (mm)",
        y="Bill depth (mm)",
    )
)

p
```

If you want to explicitly display a plot, use the `.show()` method.

```{python}
#| warning: false
p.show()
```

### Customizing display

See the following documentation pages for customizing plot display:

* Quarto: [documentation on computed figures](https://quarto.org/docs/authoring/figures.html#computations) and [figure options page](https://quarto.org/docs/computations/execution-options.html#figure-options).
* Jupyter notebooks: ["Integrating your objects with IPython"](https://ipython.readthedocs.io/en/stable/config/integrating.html).

## Saving plots

Use the `.save()` method to save a plot to a file. It takes as its first argument the name of the file to save the plot to. 

```{python}
#| eval: false
p.save("my_plot.png")

```

By default, Plotnine tries to infer the file format from its name. For example, in the code above, Plotnine would save the plot in PNG format.

## Setting size, resolution, and format

Plotnine supports customizing plot size, resolution, and format in three ways, in order of precedence:

* `.save()` method arguments.
* `theme()` settings.
* `plotnine.options.set_option()` global options.

```{python}
# | eval: false
p = ggplot(penguins, aes("bill_length_mm", "bill_depth_mm", color="species"))


# Customize in save method ---
p.save("my_plot.png", width=6, height=4, dpi=100)


# Display or save with custom theme ---
my_theme = theme(figure_size=(6, 4), dpi=100)
p + my_theme


# Save using global option ---
from plotnine.options import set_option

set_option("figure_size", (6, 4))

p.save()
```


## Handling fonts in svg

When plots using custom fonts are saved as an SVG, it may not display correctly on computers that do not have the fonts installed. Use the `svg_usefonts` argument in the `theme()` function to ensure that fonts are self-contained in the SVG file.

```{python}
#| eval: false
p + theme(svg_usefonts=False)
```
````

## File: guide/facets.qmd
````
---
title: Facets (subplots)
jupyter: python3
---

Facets split a plot into multiple subplots, based on one or more variables. `facet_wrap()` creates a sequence of subplots, while `facet_grid()` creates a matrix of subplots.

:::{.callout-tip title="You will learn"}
* How to create a sequence or matrix of subplots.
* How to use a special facetting syntax to define subplots.
* How to configure the x- and y-axis of subplots.
:::

:::{.callout-note title="Key points" collapse="true"}
* `facet_wrap()` creates a sequence of subplots.
* The `ncol` or `nrow` arguments to `facet_wrap()` control the number of columns or rows.
* `facet_grid()` creates a matrix of subplots based on two or more variables.
* The `scales` argument can set a combination of the `x` and `y` axis to fixed for free.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import mpg
```

Here is a single big plot that you might want to split into subplots.

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class")) + geom_point()
)
```

## facet_wrap(): subplot sequence

Use `facet_wrap()` to create a sequence of subplots. It accepts as its first argument the name of the column that should be used to split the data for subplots.

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point(show_legend=False)
    + facet_wrap("class")
)
```

Note that by default `facet_wrap()` fills row-by-row, with defaults for the number of subplots per row and column. Use either the `ncol=` or `nrow=` argument to fix the number of plots per column or row, respectively.

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point(show_legend=False)
    + facet_wrap("class", ncol=2)
)
```


## facet_grid(): subplot matrix

Use `facet_grid()` to create a matrix of subplots. It accepts two column names as arguments, the first for the rows and the second for the columns.

```{python}
(ggplot(mpg, aes("displ", "hwy")) + geom_point() + facet_grid("cyl", "year"))
```

## facetting syntax

Both `facet_wrap()` and `facet_grid()` support a special syntax for defining subplots. It takes the form `"var1 ~ var2 + var3"`

```{python}
(ggplot(mpg, aes("displ", "hwy")) + geom_point() + facet_grid("cyl ~ year"))
```

Notice that `cyl` values (e.g. 4, 5, 6, 8) are on the rows, while `year` values are on the columns.

 The column names to the left of the tilde (`~`) define subplot rows, while those to the right define subplot columns. The plus sign (`+`) groups variables for creating subplots.


## `scales=` for freeing axes

By default, the x- and y-axes of each subplot have the same range. Use the `scales=` argument to allow each row or column to have its own range.

```{python}
(
    ggplot(mpg, aes("displ", "hwy"))
    + geom_point()
    + facet_grid("cyl ~ year", scales="free_y")
)
```
````

## File: guide/feature-coverage.qmd
````
---
title: Feature parity with ggplot2
---

## Questions

* How to separate guides (e.g. linetype size and shape size?)
* Should people use scale_color_cmap or scale_color_continuous?

## Missing

* geom_text:
  - no manual hjust argument
  - no fontweight, fontstyle mappings (fontweight is fontface in ggplot; TODO upgrade and check)
  - aes hjust, vjust don't accept numbers (only strings like center, top, etc..)
* geom_path no linewidth option (uses size)
* Shape names not supported (see aes spec)
* `None` for do nothing not always supported
  - shape aesthetic
* Not all linetypes supported (and must be name)
  - ggplot's dotdash is dashdot
* geom_sf: would be geom_carto in plotnine. Handles crs conversions for you.

## Differences

```python
from plotnine import *
from plotnine.data import huron
ggplot(huron, aes("year", "level")) + geom_line(linetype=(0, (1, 5)),)
```

## Key syntax differences

* replace `.` with `_`
* funs and fun_y, etc..?
* `where` clause
* use quotes are mappings

## Mapping differences

* sans-serif vs sans, monospace vs mono
````

## File: guide/geom-cheatsheet.qmd
````
from https://ggplot2-book.org/layers.html#sec-position

* Graphical primitives:
  - geom_blank(): display nothing. Most useful for adjusting axes limits using data.
  - geom_point(): points.
  - geom_path(): paths.
  - geom_ribbon(): ribbons, a path with vertical thickness.
  - geom_segment(): a line segment, specified by start and end position.
  - geom_rect(): rectangles.
  - geom_polygon(): filled polygons.
  - geom_text(): text.
* One variable:
  * Discrete:
    - geom_bar(): display distribution of discrete variable.
  * Continuous:
    - geom_histogram(): bin and count continuous variable, display with bars.
    - geom_density(): smoothed density estimate.
    - geom_dotplot(): stack individual points into a dot plot.
    - geom_freqpoly(): bin and count continuous variable, display with lines.
* Two variables:
  * Both continuous:
    - geom_point(): scatterplot.
    - geom_quantile(): smoothed quantile regression.
    - geom_rug(): marginal rug plots.
    - geom_smooth(): smoothed line of best fit.
    - geom_text(): text labels.
    - Show distribution:
    - geom_bin2d(): bin into rectangles and count.
    - geom_density2d(): smoothed 2d density estimate.
    - geom_hex(): bin into hexagons and count.
  * At least one discrete:
    - geom_count(): count number of point at distinct locations
    - geom_jitter(): randomly jitter overlapping points.
    - One continuous, one discrete:
    - geom_bar(stat = "identity"): a bar chart of precomputed summaries.
    - geom_boxplot(): boxplots.
    - geom_violin(): show density of values in each group.
  * One time, one continuous:
    - geom_area(): area plot.
    - geom_line(): line plot.
    - geom_step(): step plot.
* Display uncertainty:
  * geom_crossbar(): vertical bar with center.
  * geom_errorbar(): error bars.
  * geom_linerange(): vertical line.
  * geom_pointrange(): vertical line with center.
* Spatial:
  * geom_map(): fast version of geom_polygon() for map data.
* Three variables:
  * geom_contour(): contours.
  * geom_tile(): tile the plane with rectangles.
  * geom_raster(): fast version of geom_tile() for equal sized tiles.
````

## File: guide/geometric-objects.qmd
````
---
title: "Geometric objects"
jupyter: python3
ipynb-shell-interactivity: all
---

Geometric objects (geoms) determine how to turn mapped data into visual elements–such as points, lines, or even boxplots. There are two kinds of geoms: individual and collective.

:::{.callout-tip title="You will learn"}
* What individual and collective geoms are.
* How to make side-by-side bar charts.
* How to avoid overlapping points.
* How to run statistical calculations before plotting.
:::

:::{.callout-note title="Key points" collapse="true"}
* Geoms use aesthetic mappings to draw plot elements.
* Individual geoms draw one observation (row) with one element.
* Collective geoms draw multiple observations (rows) with one element (e.g. a boxplot).
* Collective geoms include lines, which are drawn between observations.
* Use the `position=` argument to adjust the position of overlapping elements.
* Use the `stat=` argument to run calculations before plotting.
:::


## Setup

```{python}
from plotnine import *
from plotnine.data import mpg
```

## Basic use

Geom functions, like `geom_point()`, specify visual elements to draw on the plot. They're rendered in the order they're added to the plot. 

For example, the plot below adds points will fill color corresponding to the `class` column, and then points with shape corresponding to the same column.

```{python}
#| layout-nrow: 1
(
    ggplot(mpg, aes("displ", "hwy"))
    + geom_point(aes(fill="class"), size=5)
    + geom_point(aes(shape="class"))
)
```

Notice that the legend includes a guide for both fill and shape, so it's clear what each corresponds to in the chart.

## Kinds of geoms

Geoms come in two varieties:

* **Individual geoms**: draw each row of data independently on the chart.
* **Collective geoms**: draw based on groups of rows, or relationships between them.

This is shown below for points, boxplots, and lines.

```{python}
#| echo: false
#| layout-nrow: 1
small_mpg = (
    mpg[mpg["class"].isin(["2seater", "compact", "midsize"])]
    .assign(**{"class": lambda d: d["class"]})
)
model_avg_hwy = (
    small_mpg
    .groupby(["year", "class"])["hwy"]
    .agg("mean")
    .reset_index()
)

big_text = theme_grey(base_size=24)

p1 = (
   ggplot(small_mpg, aes("class", "hwy"))
   + geom_boxplot()
   + labs(title="collective: boxplot")
   + big_text
)
p2 = (
   ggplot(small_mpg, aes("class", "hwy"))
   + geom_point(position=position_jitter(height=0, width=0.1))
   + labs(title="individual: point")
   + big_text
)
p3 = (
    ggplot(model_avg_hwy, aes("year", "hwy", color="class", group="class")) 
    + geom_line(size=1)
    + geom_point()
    + labs(title="collective: line")
    + big_text
    + theme(legend_position="bottom")
    + scale_color_discrete(drop=True)
)

p2
p1
p3
```

Note that boxplots are collective because they draw the box based on all the data in a group. Lines are collective because they connect rows of data points.



## Individual: points, bars, and text

This section illustrates individual geoms. 
These range from simple points, to text, to bars and rectangles.

### Scatterplot with text

```{python}
highest_mpg = mpg[(mpg["hwy"] == mpg["hwy"].max()) & (mpg["cty"] == mpg["cty"].max())]

(
    ggplot(mpg, aes("cty", "hwy")) 
    + geom_point() 
    + geom_text(
        aes(label="model"),
        nudge_y=-2,
        nudge_x=-1,
        data=highest_mpg
    )
)
```

### Barchart on counts

```{python}
ttl_mpg_class = mpg.value_counts(["class", "drv"]).reset_index()
ttl_mpg_class.head(3)
```

```{python}
ggplot(ttl_mpg_class, aes("class", "count", fill= "drv")) + geom_col()
```

### Rectangles

Use `geom_rect()` to draw rectangles.

```{python}
import pandas as pd

df_rect = pd.DataFrame(
    {
        "xmin": [1, 2, 3],
        "ymin": [1, 2, 3],
        "xmax": [2, 3, 4],
        "ymax": [2, 3, 4],
    }
)

(
    ggplot(df_rect, aes(xmin="xmin", ymin="ymin", xmax="xmax", ymax="ymax"))
    + geom_rect(fill="orange")
)
```


## Collective: distributions

Collective geoms like `geom_boxplot()` and `geom_density()` can communicate the general shape and distribution of data.

### Boxplots and violins

Use `geom_boxplot()` and `geom_violin()` to create boxplots and violin plots, respectively.

```{python}
indx = mpg["class"].isin(["2seater", "compact", "midsize"])


(
    ggplot(aes("class", "cty"))
    + geom_boxplot(data=mpg[indx], fill="orange")
    + geom_violin(data=mpg[~indx], fill="lightblue")
)
```

### Histograms and densities

```{python}
# | layout-nrow: 1
p = ggplot(mpg, aes("cty"))
p + geom_histogram()
p + geom_density(fill="lightblue")
```

### Smoothing

```{python}
(
    ggplot(mpg, aes("displ", "hwy"))
    + geom_point()
    + geom_smooth(method="lm", color="blue", fill="orange")
)

```

## Collective: lines and fills

Lines and fills are collective geoms because they connect or fill between data points. 

For example, `geom_line()` connects points along the x-axis.
This is especially useful when x is a time series.

```{python}
from plotnine import *
from plotnine.data import huron

(
    ggplot(huron, aes("year", "level"))
    + geom_line()
    + geom_point()
)
```

Similarly, `geom_ribbon()` draws a ribbon along the x-axis, based on minimum and maximum values for the y-axis.

```{python}
from plotnine import *
from plotnine.data import huron

(
    ggplot(huron, aes("year", "level"))
    + geom_ribbon(aes(ymax="level"), ymin=0, fill="lightblue")
    + geom_point()
)
```


* `geom_area()`: a special case of `geom_ribbon()` that always sets `ymin=0`.
* `geom_path()`: connects points with a line by connecting subsequent rows of data, rather than along the x-axis.

## `position=` for placement tweaks

Use the `position=` argument to geom functions to do things like apply a small amount of random jitter. This can be useful for avoiding overplotting, where elements cover each other. Position can also move stacked bars to be side-to-side, to make them easier to compare.

### Jitter with random noise

Use `position_jitter()` to apply a small amount of random noise on the x- and y-axis. For example, the plots below show the same data with and without jitter.

```{python}
# | layout-nrow: 1
p = ggplot(mpg, aes("cty", "hwy"))

p + geom_point(alpha=0.2)
p + geom_point(position=position_jitter())
```

Notice that the first plot has points plotted on top of each other. It uses `alpha=0.2` to make overlapping points more visible. The second plot uses jitter to spread points out.

### Dodge to side-by-side

Use `position_fill()` to make stacked bars all the same height (set at 1), and `position_dodge()` to move bars side-by-side.

```{python}
# | layout-nrow: 1

from plotnine.data import diamonds

p = ggplot(diamonds, aes("color", fill="cut")) + theme(legend_position="none")

p + geom_bar()
p + geom_bar(position=position_fill())
p + geom_bar(position=position_dodge())
```

Notice that the middle plot (position fill) makes it easy to compare the proportion of each fill across groups, while the right plot (position dodge) makes it easy to compare individual bars.

## `stat=` for statistical calculations

Use the `stat=` argument to geom functions to run calculations before plotting. For example, the plot below uses `stat="summary"` with the `fun_y=` argument, to add a point for the mean of each group.

```{python}
(
    ggplot(mpg, aes("trans", "cty"))
    + geom_point()
    + geom_point(
        color="red",
        size=3,
        stat="summary",
        fun_y=lambda x: x.mean()
    )
)

```

Note that in practice it's often easier to just pass summarized data directly to a geom function. For example, the plot above could also be created with the following code.

```{python}
# | eval: false
mean_mpg = mpg.groupby("trans")["cty"].mean().reset_index()

(
    ggplot(mpg, aes("trans", "cty"))
    + geom_point()
    + geom_point(data=mean_mpg, color="red", size=3)
)

```
````

## File: guide/install.qmd
````
---
title: Installation
---

For most users, we recommend installing the official release of Plotnine.


### Installing the official release

The official release can be installed from the command line using either `pip`, `uv`, `pixi`, or `conda`:

```bash
# Using pip:
$ pip install plotnine

# Using uv:
$ uv pip install plotnine

# Using pixi:
$ pixi init name-of-project
$ cd name-of-project
$ pixi add plotnine

# Using conda:
$ conda install -c conda-forge plotnine
```

::: {.callout-note}
For `uv` you need to have a virtual environment, which you can create using `uv venv`.
Read [more information about installing and using `uv`](https://docs.astral.sh/uv/).
:::

For some functionality you may need to install extra packages.
Those packages include:

- [adjustText](https://github.com/Phlya/adjustText): For automatic label placement
- [geopandas](https://geopandas.org/en/stable/): For working with for geographic data
- [scikit-learn](http://scikit-learn.com): For Gaussian Process smoothing
- [scikit-misc](https://has2k1.github.io/scikit-misc/): For LOESS smoothing

These four packages can be installed in one go by specifying `'plotnine[extra]'` instead of `plotnine`:

```bash
# Using pip:
$ pip install 'plotnine[extra]'

# Using uv:
$ uv pip install 'plotnine[extra]'

# Using pixi:
$ pixi add 'plotnine[extra]' --pypi

# Using conda:
$ conda install -c conda-forge 'plotnine[extra]'
```


### Installing the development version

Plotnine is under active development.
It may happen that a bugfix or new feature is not yet available in the official release. 
In those cases you can install the latest development version from GitHub:

```bash
# Using pip:
$ pip install git+https://github.com/has2k1/plotnine.git

# Using uv:
$ uv pip install git+https://github.com/has2k1/plotnine.git
```

To contribute to Plotnine's source code, you have to clone the [Plotnine source repository](https://github.com/has2k1/plotnine) and install the package in development mode:

```bash
$ git clone https://github.com/has2k1/plotnine.git
$ cd plotnine
$ pip install -e .
```
````

## File: guide/introduction.qmd
````
---
title: Introduction
ipynb-shell-interactivity: all
aliases: 
  - ./index.html
---


Plotnine is a Python package for data visualization, based on the grammar of graphics. It implements a wide range of plots---including barcharts, linegraphs, scatterplots, maps, and much more.

This guide goes from a basic [overview of Plotnine code](./overview.qmd), to explaining each piece of its grammar in more detail.
While getting started is quick, learning the full grammar takes time.
But it's worth it!
The grammar of graphics shows how even plots that look very different share the same underlying structure.

The rest of this page provides brief instructions for installing and starting with Plotnine, followed by some example use cases.


## Installing

::: {.panel-tabset}

### pip

```bash
# simple install
pip install plotnine

# with dependencies used in examples
pip install 'plotnine[extra]'
```

### uv

```bash
# simple install
uv add plotnine

# with dependencies used in examples
uv add 'plotnine[extra]'
```

### pixi

```bash
# simple install
pixi init name-of-project
cd name-of-project
pixi add plotnine

# with dependencies uses in examples
pixi init name-of-project
cd name-of-project
pixi add 'plotnine[extra]' --pypi
```

### conda

```bash
# simple install
conda install -c conda-forge plotnine

# with dependencies used in examples
conda install -c conda-forge 'plotnine[extra]'
```

:::

## Quickstart

### Basic plot

Plotnine comes with over a dozen [example datasets](../reference##datasets), in order to quickly illustrate a wide range of plots.
For example, the Palmer's Penguins dataset (`plotnine.data.penguins`)  contains data on three different penguin species.

The scatterplot below shows the relationship between bill length and bill depth for each penguin species.


```{python}
#| warning: false
from plotnine import ggplot, aes, geom_point, labs
from plotnine.data import penguins

(
    ggplot(penguins, aes("bill_length_mm", "bill_depth_mm", color="species"))
    + geom_point()
)
```

### DataFrame support

Plotnine supports both Pandas and Polars DataFrames.
It also provides simple a `>>` operator to pipe data into a plot.

The example below shows a Polars DataFrame being filtered, then piped into a plot.

```{python}
#| warning: false
import polars as pl

pl_penguins = pl.from_pandas(penguins)

(
    # polars: subset rows  ----
    pl_penguins.filter(pl.col("species") == "Adelie")
    #
    # pipe to plotnine ----
    >> ggplot(aes("bill_length_mm", "bill_depth_mm", fill="species"))
    + geom_point()
    + labs(title="Adelie penguins")
)
```

Notice that the code above keeps the Polars filter code and plotting code together (inside the parentheses). This makes it easy to quickly create plots, without needing a bunch of intermediate variables.

## Use cases


See the [Plotnine gallery](../gallery/) for more examples.

### Publication ready plots

```{python}
# | code-fold: true
from plotnine import *
from plotnine.data import anscombe_quartet

(
    ggplot(anscombe_quartet, aes("x", "y"))
    + geom_point(color="sienna", fill="orange", size=3)
    + geom_smooth(method="lm", se=False, fullrange=True, color="steelblue", size=1)
    + facet_wrap("dataset")
    + labs(title="Anscombe’s Quartet")
    + scale_y_continuous(breaks=(4, 8, 12))
    + coord_fixed(xlim=(3, 22), ylim=(2, 14))
    + theme_tufte(base_family="Futura", base_size=16)
    + theme(
        axis_line=element_line(color="#4d4d4d"),
        axis_ticks_major=element_line(color="#00000000"),
        axis_title=element_blank(),
        panel_spacing=0.09,
    )
)
```

### Annotated charts

The plot below makes heavy use of annotation, in order to illustrate coal production over the past century. 
The chart is largely Plotnine code, with matplotlib for some of the fancier text annotations.
Learn more on in [this blog post](https://nrennie.rbind.io/2024-plotnine-contest/) by the author, Nicola Rennie.

![](./assets/nrennie-coal-production.png)

### Geospatial plots


[See maps page](./maps.qmd)

```{python}
# | code-fold: true
from plotnine import *
import geodatasets
import geopandas as gp

chicago = gp.read_file(geodatasets.get_path("geoda.chicago_commpop"))

(
    ggplot(chicago, aes(fill="POP2010"))
    + geom_map()
    + coord_fixed()
    + theme_minimal()
    + labs(title="Chicago Population in 2010")
)
```

### Getting artsy

```{python}
# | code-fold: true
import polars as pl
import numpy as np

from plotnine import *
from mizani.palettes import brewer_pal, gradient_n_pal

np.random.seed(345678)

# generate random areas for each group to fill per year ---------
# Note that in the data the x-axis is called Year, and the
# filled bands are called Group(s)

opts = [0] * 100 + list(range(1, 31))
values = []
for ii in range(30):
    values.extend(np.random.choice(opts, 30, replace=False))


# Put all the data together -------------------------------------
years = pl.DataFrame({"Year": list(range(30))})
groups = pl.DataFrame({"Group": [f"grp_{ii}" for ii in range(30)]})

df = (
    years.join(groups, how="cross")
    .with_columns(Values=pl.Series(values))
    .with_columns(prop=pl.col("Values") / pl.col("Values").sum().over("Year"))
)


# Generate color palette ----------------------------------------
# this uses 12 colors interpolated to all 30 Groups
pal = brewer_pal("qual", "Paired")

colors = pal(12)
np.random.shuffle(colors)

all_colors = gradient_n_pal(colors)(np.linspace(0, 1, 30))


# Plot ---------------------------------------------------------
(
    df
    >> ggplot(aes("Year", "prop", fill="Group"))
    + geom_area()
    + scale_fill_manual(values=all_colors)
    + theme(
        axis_text=element_blank(),
        line=element_blank(),
        title=element_blank(),
        legend_position="none",
        plot_margin=0,
        panel_border=element_blank(),
        panel_background=element_blank(),
    )
)
```



## Next steps

Continue to the [Overview](./overview.qmd) for a worked example breaking down each piece of  Plotnine's grammar of graphics.
````

## File: guide/labels.qmd
````
---
title: Labels and titles
jupyter: python3
execute:
  # disable warnings for missing values in penguins dataset
  warning: false
---

:::{.callout-tip title="You will learn"}
* How to categorize the three kinds of labels in a plot.
* How to set each kind of label.
* How to style labels (e.g. with color).
:::

:::{.callout-note title="Key points" collapse="true"}
* The three kinds of labels are plot labels, guide labels, and scale break labels.
* The `labs()` function quickly sets plot labels and guide names.
* The `scale_*()` functions can set scale break labels.
* The `theme()` function can style labels, by changing their color, size, or more.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import penguins

p = (
    ggplot(penguins, aes("flipper_length_mm", "body_mass_g", color="species"))
    + geom_point()
)

```

## Three kinds of labels

Here is a plot, with the three kinds of labels marked.

![](./assets/plot-labels-marked.png)


* **Plot labels**: titles, subtitles, captions. (Shown in purple).
* **Guide names**: axis labels, legend titles. (Shown in red).
* **Scale breaks**: tick labels, color glyph labels. (Shown in orange).


In the following sections, we'll cover how the first two kinds of labels can quickly be set with the `labs()` function, and how scale breaks can be labeled using `scale_*()` functions.


## Labelling quickly with `labs()`

Use the `labs()` function to quickly set plot labels and guide names.

```{python}
p + labs(
    title="Penguin flipper length vs body mass",
    x="Flipper length (mm)",
    y="Body mass (g)",
    color="SPECIES",
)
```

Notice that the only piece it can't set is the break labels (e.g. the x-axis tick labels), which is often enough for most plots.

## Styling labels with theme() 

Use the `theme()` function to style labels. For example, by changing their color or size.

```{python}
(
    ggplot(penguins, aes("flipper_length_mm", "body_mass_g"))
    + geom_point()
    + theme(
        axis_text_x=element_text(color="orange"),
        axis_title_x=element_text(color="blue", size=16),
    )
)
```


## Scale breaks labels

Use the `labels=` arguments to the appropriate `scale_*()` function, in order to customize break labels.

For example, the code below changes the y-axis labels from grams to kilograms.

```{python}
(
    p
    + scale_y_continuous(labels=lambda x: [val / 1_000 for val in x])
    + labs(y="Body mass (kg)")
)

```

See [Scale basics](./scale-basics.qmd#labels-for-break-labels) for more on setting break labels.
````

## File: guide/maps.qmd
````
---
title: Maps
jupyter: python3
---

```{python}
from plotnine import *
import geodatasets
import geopandas as gp

chicago = gp.read_file(geodatasets.get_path("geoda.chicago_commpop"))
groceries = gp.read_file(geodatasets.get_path("geoda.groceries"))

```

```{python}
(
    ggplot(chicago)
    + geom_map() 
    + coord_fixed()
)

```

```{python}

(
    ggplot(chicago, aes(fill="POP2010"))
    + geom_map() 
    + coord_fixed()
)
```


```{python}
(
    ggplot(chicago, aes(fill="POP2010"))
    + geom_map()
    #+ scale_fill_cmap('plasma')
    #+ scale_fill_gradientn(["green", "purple", "papayawhip"])
    #+ scale_fill_gradient(low="green", high="blue")
    #+ scale_fill_gradient2()
)
# scale_fill_gradient
# scale_fill_continuous

```


```{python}
(
    ggplot(chicago)
    + geom_map(fill=None)
    #+ geom_map(fill=None)
    + theme_void()
    + coord_fixed()
)

```

### Missing data


```{python}
import numpy as np

chi_missing = chicago.copy()
chi_missing.loc[np.random.choice(chicago.index, 50), 'POP2010'] = np.nan

(
    ggplot(chi_missing, aes(fill="POP2010"))
    + geom_map()
)

```

```{python}
(
    ggplot(chi_missing, aes(fill="POP2010"))
    + geom_map(color="none")
    + theme_void()
    + scale_fill_continuous(na_value="lightgrey")
)
```

```{python}

(
    ggplot()
    + geom_map(data=chicago, fill=None)
    + geom_map(data=groceries.to_crs(chicago.crs), color="green")
    + theme_void()
    + coord_fixed()
)

```
````

## File: guide/misc.qmd
````
---
title: Misc
---


## geom_map(): texas house prices
````

## File: guide/operators.qmd
````
---
title: "Operators: +, >>, |, /"
jupyter: python3
---

Plotnine overloads the `+` and `>>` operators to make it easier to compose and pass data to plots.
It also overloads the `|` and `/` operators to [compose multiple plots](./plot-composition.qmd) together. You might also see `&`, and `*` used for adding components to composed plots.

This page covers the basics of the `+` and `>>` operators, along with an explanation for why they exist.

```{python}
from plotnine import *
from plotnine.data import mpg
```

## The `+` operator

Use `+` to add geoms, scales, and themes to a plot.

```{python}
# | layout-nrow: 1
(
    ggplot(mpg, aes("displ", "hwy"))
    + geom_point(aes(fill="class"))  # first geom
    + theme_minimal()  # theme
)
```

## The `>>` operator

Use the `>>` operator to pipe data into a plot.

```{python}
(
    mpg
    # piped into plot
    >> ggplot(aes("displ", "hwy", fill="class")) + geom_point()
)
```

## Why operators?

### Composable and extendable

Operators enable plot actions to use syntax that's composable and extendable. This means two things:

* **composable**: you can add additional components like geoms to a plot.
* **extendable**: components defined in other libraries---like new kinds of geoms---can be added to a plot using the same `+` syntax.

For example, suppose you [defined your own Plotnine theme](./themes-basics.qmd), as shown below:

```{python}
def my_theme(base_size=11):
    return (
        theme_grey(base_size=base_size)  # start with grey theme
        + theme(axis_text_x=element_text(angle=90))  # customize x-axis
    )
```

You can use this theme with the `+` operator, just like the built-in Plotnine themes:


```{python}
(
    ggplot(mpg, aes("displ", "hwy", fill="class"))
    + geom_point()
    + my_theme(base_size=16)  # apply custom theme
)
```

Notice that the custom `my_theme()` component was added to the plot, in the same way anything else is (e.g. `geom_point()`).

### Keep method chains going

The `>>` operator allows you to keep method chains going, without needing to create intermediate variables.
This is especially useful when using Polars DataFrames, where you often want to do small bits of data wrangling before piping into the plot.

```{python}
import polars as pl

pl_mpg = pl.from_pandas(mpg)

(
    pl_mpg
    #
    # label high mpg cars
    .with_columns(good_mpg=pl.col("hwy") > 30)
    #
    # remove compact cars
    .filter(pl.col("class") != "compact")
    #
    # pipe into plot
    >> ggplot(aes("displ", "hwy", fill="good_mpg")) + geom_point()
)
```

## Is overloading operators "Pythonic"?

Sometimes people ask whether overloading the `+` and `>>` operators is "Pythonic" -- meaning that it follows standard conventions for Python code. This is a tricky question to answer, but there are two cases that point to "yes":

* The builtin `pathlib` library overloads `/` to good effect.
* Tools like Polars use operators to compose selectors.

### `pathlib` example

```{python}
from pathlib import Path

Path("a/b") / "c"
```

In this case, the `/` operator makes it quick to add to a path (by returning a new Path object). Similarly, the Plotnine `>>` operator makes it easy to go from DataFrame method chaining into a plot.

### Polars example

```{python}
import polars as pl
import polars.selectors as cs

df = pl.DataFrame({"ttl_a": [1], "ttl_b": [2], "ttly": [3]})

# get cols starting with "ttl" but not "ttly"
selector = cs.starts_with("ttl") - cs.by_name("ttly")

df.select(selector)
```

Each selector (like `starts_with`) specifies a way to select columns, while operators like `-` provide ways to combine them. Similarly, each geom in Plotnine specifies a piece to include in a plot, while the `+` operator makes it easy to assemble pieces.
````

## File: guide/overview.qmd
````
---
title: Overview
---

This page provides an overview of Plotnine's most important concepts and corresponding syntax.
Throughout this overview, we'll focus on reproducing the plot below, which looks at city (`cty`) versus highway mileage (`hwy`) across different years of cars:

```{python}
# | code-fold: true
from plotnine import *
from plotnine.data import mpg

(
    ggplot(mpg, aes("cty", "hwy"))
    + geom_point(mapping=aes(colour="displ"))
    + geom_smooth(method="lm", color="blue")
    + scale_color_continuous(cmap_name="viridis")
    + facet_grid("year ~ drv")
    + coord_fixed()
    + theme_minimal()
    + theme(panel_grid_minor=element_blank())
)
```

:::{.callout-note}
If you haven't [installed Plotnine](./install.qmd), you can do so with:

```bash
pip install plotnine
```
:::


## Specifying data

Every plot in Plotnine starts with passing data to the `ggplot()` function.
The data can be a Pandas or Polars DataFrame.
Plotnine works best when the data is in a [tidy format](https://aeturrell.github.io/python4DS/data-tidy.html), which tends to be longer---with more rows and fewer columns.

```{python}
from plotnine import *
from plotnine.data import mpg

ggplot(data=mpg)
```

## `aes()` mapping

The `aes()` function maps columns of data onto graphical attributes--such as colors, shapes, or x and y coordinates. (The name `aes()` is short for aesthetic.)

We can map the `cty` and `hwy` columns to the x- and y- coordinates in the plot using the code below:

```{python}
ggplot(data=mpg, mapping=aes(x="cty", y="hwy"))
```

## `geom_*()` objects

Functions starting with `geom_*()` specify geometric objects (geoms) to add to the plot.
Geoms determine *how* to turn mapped data into visual elements--such as points, lines, or even boxplots.

Here is how we can map the `cty` and `hwy` columns to points with a smooth trend line on top:

```{python}
(
    ggplot(mpg, aes("cty", "hwy"))
    # to create a scatterplot
    + geom_point()
    # to fit and overlay a loess trendline
    + geom_smooth(method="lm", color="blue")
)
```

## `scale_*()` translations

The `scale_*()` functions customize the styling of visual elements from a data mapping.
This includes color palettes, axis spacing (e.g. log scale), axis limits, and more.
Scales can set the names on guides like axes, legends, and colorbars.

The names of scales follow the pattern `scale_<aesthetic>_<type>`, where `<aesthetic>` is the name of an aesthetic attribute, like `x`, `y`, or `color`.
If we want to use the `plasma` palette for color, we can use the code below:

```{python}
(
    ggplot(mpg, aes("cty", "hwy", color="displ"))
    + geom_point()
    + scale_color_continuous(name="displ (VIRIDIS)", cmap_name="viridis")
)
```

## `position_*()` adjustments

The `position_*()` functions adjust the position of elements in the plot.
For example, by adding a small amount of random noise (jitter) to the x- and y- coordinates of points, so they don't cover each other.

```{python}
(
    ggplot(mpg, aes("cty", "hwy", color="displ"))
    # add a small amount of jitter
    + geom_point(position=position_jitter())
)
```

## `facet_*()` subplots

Facets split a plot into multiple subplots.
The two facet functions, `facet_grid()` and `facet_wrap()`, determine how to split the data.
For example, we can create a grid of plots based on the `year` and `drv` columns:

```{python}
(
    ggplot(mpg, aes("cty", "hwy"))
    + geom_point()
    # facet into subplots
    + facet_grid("year ~ drv")
)
```

## `coord_*()` projections

The `coord_*()` functions specify the coordinate system of the plot.
Currently, only a few coordinate systems are available.
However, in the future systems like `coord_polar()` will allow for plotting using polar coordinates.

The code below uses `coord_fixed()` to ensure that the x- and y- axes have the same spacing.

```{python}
(
    ggplot(mpg, aes("cty", "hwy"))
    + geom_point()
    + coord_fixed(xlim=[0, 40], ylim=[0, 40])
)
```

## `theme_*()` styling

Themes control the style of all aspects of the plot that are not decided by the data.
This includes the position of the legend, the color of the axes, the size of the text, and much more.

Use the `theme_*()` functions to start with a pre-made theme, or the general `theme()` function to create a new custom theme.
Use the `element_*()` functions to configure new theme settings.

```{python}
(
    ggplot(mpg, aes("cty", "hwy", colour="class"))
    + geom_point()
    + theme_minimal()
    + theme(
        legend_position="top",
        axis_line=element_line(linewidth=0.75),
        axis_line_x=element_line(colour="blue"),
    )
)
```


## Putting it together

Finally, we put all the pieces together into the original plot:

```{python}
(
    ggplot(mpg, aes("cty", "hwy"))
    + geom_point(mapping=aes(colour="displ"))
    + geom_smooth(method="lm", color="blue")
    + scale_color_continuous(cmap_name="viridis")
    + facet_grid("year ~ drv")
    + coord_fixed()
    + theme_minimal()
    + theme(panel_grid_minor=element_blank())
)
```

:::{.callout-note}
This tutorial was adapted from the [ggplot2 "Getting Started" tutorial](https://ggplot2.tidyverse.org/articles/ggplot2.html)
:::
````

## File: guide/plot-composition.qmd
````
---
title: "Plot composition"
jupyter: python3
---

Plot composition is the process of combining multiple plots together.
Plotnine overloads the `|` and `/` operators for putting plots side-by-side or stacked vertically. It also provides the `&`, `*`, and `+` operators for adding components to parts of composed plots.

This page covers the basics of plot composition. See the [Compose Reference page](`plotnine.composition.Compose`) for more details.

## Big example

```{python}
# | warning: false
from plotnine import *
from plotnine.data import mtcars

p1 = ggplot(mtcars) + geom_point(aes("wt", "mpg")) + labs(tag="a)")
p2 = ggplot(mtcars) + geom_boxplot(aes("wt", "disp", group="gear")) + labs(tag="b)")
p3 = ggplot(mtcars) + geom_smooth(aes("disp", "qsec")) + labs(tag="c)")
p4 = ggplot(mtcars) + geom_bar(aes("carb"))

(p1 | p2 | p3) / p4
```

Notice the following pieces in the code:

* `|` places plots side-by-side.
* `/` stacks plots vertically.
* `labs(tag=...)` adds a label to the top-left of each plot.

## Tag position

Use theme(plot_tag_position=...) to change the position of the tag on a plot.

```{python}
p1 | (p2 + theme(plot_tag_position="bottom-right"))
```

Notice that the tag for `p2` ("b)") is now at the bottom-right.

## Adding to composed plots

Use the `&`, `*`, or `+` operators to add components like geoms, scales, or themes to plots in a plot composition. The `&` operator adds to all plots in a composition, while `*` and `+` add to the first or last plot, respectively.

```{python}
# | eval: false
composed = p1 | p2

composed & theme_minimal()  # themes both plots
composed * theme_minimal()  # themes first plot (p1)
composed + theme_minimal()  # themes last plot (p2)
```

## Adding margins to plots

Use options like `theme(plot_margin_left=...)` to add margins to plots. Margins can be added to the left, right, top, or bottom of a plot.

```{python}
p1 | p2 + theme(plot_margin_left=0.20)
```

Notice that a left margin was added to the second plot (`p2`).

## Inserting space between plots

Use `plot_spacer()` to insert space between plots.

```{python}
from plotnine.composition import plot_spacer

(p1 | p2) / (p1 | plot_spacer() | p2)
```

Notice that the top row has the plots side-by-side, while the bottom row puts a space between them.

## Nesting level

Nesting level determines the proportion of space a plot (or group of plots) is given. Essentially, each group of plots is a nesting level, and because groups of plots can hold other groups, you can have multiple levels of nesting. This may sound confusing, so this section will start with an example, before explaining nesting levels in more detail.

Use the `-` operator to put the right-hand plot in its own group, giving it twice as much space as each individual plot on the left.


```{python}
# | warning: false
top = p1 | p2 | p3 | p4  # all on same nesting level
bot = (p1 | p2 | p3) - p4  # p1, p2, p3 grouped (lower nesting level)

top / bot
```

Notice that the top row gives each plot panel equal space, while the bottom row gives equal space to the plot panel on the right (the one added with `-`).

A key here is that the plot panel is the space where geoms are drawn (e.g. points or bars), which excludes areas like the axes and legends.
The plot panels for the four bottom plots are marked below.

![](./assets/plot-composition-panels.png)

By default each `|` adds the plot on the right to the group of plots on the left, and each side-by-side plot in a group is given equal horizontal space. The `-` operator creates a new group consisting of the left-hand group and the right-hand plot. In this case, each group is a separate nesting level.

### More on grouping

Here's a diagram of the nesting levels for the example above.

**Grouping code.**

```python
top = p1 | p2 | p3 | p4  # all on same nesting level
bot = (p1 | p2 | p3) - p4  # p1, p2, p3 grouped (lower nesting level)

top / bot
```

**Nesting levels.**

```
* level 1 (`/` stack operator)

  # TOP ROW
  - level 2:
    - p1
    - p2
    - p3
    - p4

  # BOTTOM ROW
  - level 2:
    - level 3:
      - p1
      - p2
      - p3
    - level 3:
      - p4
```
````

## File: guide/position-adjustments.qmd
````
---
title: Position adjustments
---

Position adjustments determine the placement of overlapping geoms. For example, they can jitter points by applying a small amount of noise, or dodge bars to put them side-by-side.
Use the `position=` argument to geoms to specify adjustments.

:::{.callout-tip title="You will learn"}
* How to avoid overplotting by jittering points.
* How to make side-by-side bar charts.
* How to make stacked bar charts with equal heights.
* How to apply the same position adjustment to multiple geoms.
:::

:::{.callout-note title="Key points" collapse="true"}
* Use the `position=` argument to geoms to specify position adjustments.
* `position_jitter()` adds a small amount of noise to points.
* `position_dodge()` places bars side-by-side.
* `position_fill()` stacks bars to the same height.
* Explicitly add rows for missing data when dodging bars.
* Often, setting parameters like `position_dodge(width=...)` is necessary to align adjustments across geoms.
:::


## Setup

```{python}
from plotnine import *
from plotnine.data import diamonds
```

## Jittering points

Use `position_jitter()` to add a small amount of noise to the x- and y-axis for geoms like points. This enables viewers to see overlapping items on dense plots.

The plots below show points before and after applying jitter.

```{python}
# | layout-nrow: 1
p = ggplot(diamonds.head(1000), aes("cut", "carat", fill="clarity"))

p + geom_point()
p + geom_point(position=position_jitter())
```

## Stacking, filling, and dodging bars

By default, geoms like `geom_bar()` stack bars on top of each other (`position_stack()`). Use `position_fill()` to make the stacked bars all together the same height (set at 1), and `position_dodge()` to move bars side-by-side.

```{python}
# | layout-nrow: 1
from plotnine.data import diamonds

p = ggplot(diamonds, aes("color", fill="cut")) + theme(legend_position="none")

p + geom_bar(position=position_stack())  # default
p + geom_bar(position=position_fill())
p + geom_bar(position=position_dodge())
```

### Reversing order

The `position_stack()` and `position_fill()` functions supports a `reverse` argument. This reverses the order within stacked bars.

```{python}
#| layout-nrow: 1
p = ggplot(diamonds, aes("color", fill="cut"))

p + geom_bar(position=position_fill())
p + geom_bar(position=position_fill(reverse=True))
```

### Spacing between dodged bars

Use the `width` argument to `position_dodge()` to increase or decrease the spacing between dodged bars.

```{python}
# | layout-nrow: 1
import pandas as pd

df = pd.DataFrame({"x": [1, 1, 2, 2], "n": [1, 2, 3, 4], "fill": ["A", "B"] * 2})

ggplot(df, aes("x", "n", fill="fill")) + geom_col(position=position_dodge(width=0.5))
```

Notice that setting `width=0.5` caused the bars to overlap. Setting width higher increases the distance between the center of the bars.

### Labelling bars

If you want to add a label to dodged bars, it's often necessary to set the dodge width for both the bars and the text.

```{python}
dodge = position_dodge(width=0.6)
(
    ggplot(df, aes("x", "n", fill="fill", label="n"))
    + geom_col(position=dodge, width=0.5)
    + geom_text(position=dodge)
)
```

### Jitterdodging

If you want to combine jittering and dodging, use `position_jitterdodge()`. 

## Dodging with missing bars

When dodging bars, if a bar is missing from the plot (e.g. due to missing data), it often shows up by making another bar especially wide.

```{python}
from plotnine.data import mpg

ggplot(mpg, aes("class", fill="factor(cyl)")) + geom_bar(position=position_dodge())
```

Notice that 2seater on the left has only a single bar that's as wide as car classes with 4 bars. This is because bars occupy the same amount of room within an x-axis grouping.

In order to preserve space within a grouping for missing bars, you can calculate counts yourself, and add explicit rows for missing combinations in the data.

```{python}
df_crossed = mpg[["cyl"]].merge(mpg[["class"]], how="cross")

# count rows, then explicitly add 0 counts for missing combinations
full_counts = (
    mpg.groupby(["cyl", "class"])
    .size()
    .reset_index(name="n")
    .merge(df_crossed, how="right")
    .fillna(0)
)

(
    ggplot(
        full_counts,
        aes("class", "n", color="factor(cyl)", fill="factor(cyl)"),
    )
    + geom_col(position=position_dodge())
)
```

Note that setting the `color=` aesthetic makes the bars with height 0 visible (by setting the color of the rectangle border).

## Dodging lines and points

When dodging lines and points, the `width=` argument to `position_dodge()` is necessary.




```{python}
df = pd.DataFrame(
    {
        "group": ["A"] * 2 + ["B"] * 2,
        "condition": ["treatment", "control"] * 2,
        "measure": [3, 1, 2, 1],
    }
)


dodge = position_dodge(width=0.1)

(
    ggplot(df, aes("condition", "measure", fill="group", group="group"))
    + geom_line(position=dodge)
    + geom_point(size=4, position=dodge)
    + expand_limits(y=0)
)
```

## Nudge a fixed amount

Use `position_nudge()` to move points or text a fixed amount in the x- and y-directions.


```{python}
highest_mpg = mpg[(mpg["hwy"] == mpg["hwy"].max()) & (mpg["cty"] == mpg["cty"].max())]

(
    ggplot(mpg, aes("cty", "hwy"))
    + geom_point()
    + geom_text(
        aes(label="model"),
        position=position_nudge(x=-1, y=-2),
        data=highest_mpg,
    )
)
```

Note however that geoms like `geom_text()` provide `nudge_x` and `nudge_y` arguments that are more convenient for nudging text.
````

## File: guide/scale-basics.qmd
````
---
title: Scales, legends, and guides
jupyter: python3
ipynb-shell-interactivity: all
---

```{python}
# | include: false
# TODO: need more general approach for shortening warnings in docs
import warnings
from warnings import WarningMessage, _formatwarnmsg_impl


def new_formatwarning(message, category, filename, lineno, line=None):
    return f"{category.__name__}: {message}\n"


warnings.formatwarning = new_formatwarning
```

Scales specify how aesthetic mappings are ultimately styled as colors, shapes, positions, sizes, and more. This includes choosing the colors used or scaling the size of points based on values of data.

Scale functions follow the naming pattern `scale_{aesthetic}_{type}`, where aesthetic is the name of the mapping (e.g. `x`, `y`, `fill`, `shape`), and type is the type of scale (e.g. `continuous`, `discrete`, `color`, `shape`).

Plotnine produces a legend automatically, which tells viewers how to map scale values back to the underlying data. These mappings back to data are called guides.


:::{.callout-tip title="You will learn"}
* How to apply a custom color palette.
* How to choose between discrete, continuous, and manual scales.
* How to log transform x- and y-axes.
* How to customize x- and y-axis, and legend names.
* How to restrict the range of axes and color palettes.
* How to customize guide boxes in legends.
:::

:::{.callout-note title="Key points" collapse="true"}
* Scale functions follow the pattern `scale_{aesthetic}_{type}` (e.g. `scale_color_continuous`)
* Scales have default types based on the aesthetic and data.
* Scales have an identity type that uses data values directly.
* Position scale types include log and reverse.
* Common scale arguments:
  - `name=` sets guide names.
  - `values=` sets manual styles (e.g. color or shape).
  - `breaks=` sets pieces like axis ticks.
  - `limits=` restricts the range of the scale.
  - `labels=` sets custom labels for breaks.
* Legends can be merged by giving scales the same name.
* `theme(legend_position=...)` sets the position of the legend.
* The `guide_*()` functions customize pieces like reversing a colorbar.
:::

## Setup

```{python}
from plotnine import *
from plotnine.data import mpg
```

## Scale basics

In order to illustrate scales, we'll show two very different uses: manually mapping values of data to colors, and selecting a color palette.

For manually mapping values to colors, we can use a manual type scale. For example, the code below uses `scale_color_manual()` to map two values in the `class` column to classes to red and blue.

```{python}
# | warning: false
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point()
    + scale_color_manual(
        name="Car class",
        breaks=["2seater", "compact"],
        values=["red", "blue"],
    )
)
```

Notice that "2seater" is red, "compact" is blue, and all other points are grey. The box on the right side of the plot with "Car class" in it is the legend. The piece inside it showing the colors with "2seater" and "compact" labeled is called a guide.

Generally, when using scales you'll often want to use a scale that can automatically map values to colors. For example, `scale_color_brewer()` automatically applies a [ColorBrewer](https://colorbrewer2.org/) palette.

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point()
    + scale_color_brewer(type="qual", palette=2)
)
```

Notice that there are 7 colors in the plot, one for each level of the `class` column.

## Scale parts

Scales have many parts, including the overall guide, breaks, break labels, and break values (shown below).

![](./assets/plot-guides-marked.png)

Notice the pieces marked in the diagram above:

* **Guide**: the x-axis, y-axis, and the color guide on the right.
* **Breaks**: the data points where pieces like labels are applied.
* **Break labels**: the text displayed for each break.
* **Break values**: pieces like the position on the axis, or key color in the color guide for a break.

## Varieties of scales


### Default scales

Different scale types are applied by default, depending on the kind of data being mapped. For example, `scale_color_continuous()` is the default for numeric data, but `scale_color_discrete()` is the default for string data.

The plots below illustrate this for the continuous `cyl` column, by plotting it as is on the left, and using the special `"factor(cyl)"` syntax to cast it to discrete on the right.

```{python}
# | layout-nrow: 1
p = ggplot(mpg, aes("displ", "hwy")) + theme_grey(base_size=20)

# defaults to scale_color_continuous
p + geom_point(aes(color="cyl"))

# defaults to scale_color_discrete
p + geom_point(aes(color="factor(cyl)"))
```

### Position scales

The **position scales** for the x- and y-axis also have many extra transformations available. For example, reversing or log transforming.

```{python}
(ggplot(mpg, aes("displ", "hwy")) + geom_point() + scale_x_reverse() + scale_y_log10())
```

### Identity type

Finally, the scale **identity type** uses the values of the data as styles directly. For example, the code below sets the color of points to the values in the `my_color` column.

```{python}
import pandas as pd

df = pd.DataFrame(
    {
        "x": [1, 2, 3],
        "y": [1, 2, 3],
        "my_color": ["red", "blue", "green"],
    }
)

(ggplot(df, aes("x", "y", color="my_color")) + geom_point(size=5) + scale_color_identity())
```

## `name=` to set guide (legend) labels

Use the `name=` argument to scale functions to set the label of that scale's guide.

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point()
    + scale_x_continuous(name="Engine displacement (litres)")
    + scale_y_continuous(name="Highway miles per gallon")
    + scale_color_discrete(name="Car class")
)
```

Notice that the x-axis, y-axis, and color guides all have names set. While the guide color is in the legend on the right, the x- and y-axis guides are on the bottom and left of the plot.

:::{ .callout-tip title="labs() shortcut"}
The `labs()` function is a convenient way to set names for guides in one place, along with other pieces like a title.

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point()
    + labs(
        title="Use labs() to quickly set labels",
        x="Engine displacement (litres)",
        y="Highway miles per gallon",
        color="Car class"
    )
)
```

:::

## `values=` for manual styles

Use the `values=` argument to manually specify stylings like colors, shapes, or sizes of the scale. For example, the plot below manually sets point shapes (see the [aesthetic specification](./aesthetic-specification.qmd#point) for shape value options).

```{python}
keep_classes = ["2seater", "compact", "midsize"]

(
    mpg[mpg["class"].isin(keep_classes)]
    >> ggplot(aes("displ", "hwy", shape="factor(cyl)"))
    + geom_point()
    + scale_shape_manual(values=[".", "o", "v", ">"])
)
```

## `breaks=` for axis ticks, color bins

```{python}
p = ggplot(mpg, aes("displ", "hwy", color="class")) + geom_point()

p + scale_x_continuous(breaks=[4, 4.5, 5, 5.5])
```

```{python}
# | layout-nrow: 1
# | eval: false
# | include: false

# TODO: I'm actually not sure the intended difference between breaks and limits here. Behavior seems inconsistent depending on scale type.
p = ggplot(mpg, aes("displ", "hwy", color="class")) + geom_point(size=4)

p + scale_color_discrete(breaks=["2seater", "compact"]) + labs(title="Setting breaks")
p + scale_color_discrete(limits=["2seater", "compact"]) + labs(title="Setting limits")
```


## `limits=` for restricting data range

```{python}
# | layout-nrow: 1
from plotnine.data import huron


p = ggplot(huron, aes("year", "level")) + geom_line() + theme_grey(base_size=26)

p + labs(title="default")
p + scale_x_continuous(limits=[1950, 1960]) + labs(title="zoom in")
p + scale_x_continuous(limits=[1800, 2000]) + labs(title="zoom out")
```

Notice two important pieces:

* The second plot is more zoomed in, so excludes some data (e.g. years before 1950).
* The `PlotnineWarning` printed before the plots comes from the zoomed in plot, and indicates that zooming in cut off 87 rows. When data falls outside limits, Plotnine treats them like missing values.



```{python}
#| layout-nrow: 1
p = ggplot(huron, aes("year", "level", color="year")) + geom_line() 

p
p + scale_color_continuous(limits=[None, 1900])
```

## `labels=` for break labels

Use the `labels=` argument to set custom labels for breaks. This argument supports either a function that operates on a list of breaks, or a list of labels.

For example, the plot below sets the color labels to uppercase.

```{python}
p = ggplot(mpg, aes("displ", "hwy", color="class")) + geom_point()

p + scale_color_discrete(labels=lambda breaks: [s.upper() for s in breaks])
```

The plot below manually sets the x-axis breaks and labels.

```{python}
p + scale_x_continuous(breaks=[2, 4, 6], labels=["TWO", "FOUR", "SIX"])

```

## Legend merging

Sometimes aesthetics mapped to the same variable have their guides merged. For example, color and shape might be shown on the same guide. To split a merged guide, give the scales their own names.

```{python}
# | layout-nrow: 1
p = (
    ggplot(mpg, aes("displ", "hwy", color="factor(cyl)", shape="factor(cyl)"))
    + geom_point()
    + theme_grey(base_size=20)
)

p + labs(title="Unmerged")
p + labs(title="Merged") + scale_shape_discrete(name="Shape")
```

## Legend position

Use `theme(legend_position=...)` argument to set the position of the legend in a plot. The options are `"none"`, `"left"`, `"right"`, `"top"`, and `"bottom"`.

```{python}
# | layout-nrow: 1
p = (
    ggplot(mpg, aes("displ", "hwy", color="factor(cyl)", shape="factor(cyl)"))
    + geom_point()
)

p + theme(legend_position="top")
p + theme(legend_position="none")
```

## Guide customization

Customize guides by passing arguments like `guide_colorbar()` or `guide_legend()` to the `guides()` function.

The example below uses `guide_colorbar()` to reverse the colorbar (in the legend on the right; note the styles are the same, but the way the guide colorbar is shown is reversed).

```{python}
# | layout-nrow: 1
p = (
    ggplot(mpg, aes("displ", "hwy", color="cyl"))
    + geom_point()
    + theme(legend_key_size=30)
)
p
p + guides(color=guide_colorbar(reverse=True))
```

Here's a funky example that merges guides for color, size, and shape by giving them all the same title in the legend.


```{python}
# | warning: false
import pandas as pd
from plotnine import *

ser = list(map(str, range(5)))
df = pd.DataFrame({"x": ser, "y": ser, "p": ser, "q": ser, "r": ser})

(
    ggplot(df, aes("x", "y", color="p", size="q", shape="r"))
    + geom_point()
    + labs(title="Merged color, size, and shape guides")
    + guides(
        color=guide_legend("THE GUIDE"),
        size=guide_legend("THE GUIDE"),
        shape=guide_legend("THE GUIDE"),
    )
)

```
````

## File: guide/scale-breaks-labels.qmd
````
---
title: Scale breaks and labels
---
````

## File: guide/scale-color-fill.qmd
````
---
title: Scale color and fill
jupyter: python3
execute:
  # disable warnings for missing values in penguins dataset
  warning: false
---

```{python}
from plotnine.data import penguins
from plotnine import *

p = (
    ggplot(penguins, aes("bill_length_mm", "bill_depth_mm", color="species"))
    + geom_point()
)
```

## Choosing between color and fill

## Specifying a continuous palette


## Specifying a discrete palette

```{python}
p + scale_color_brewer("qualitative", palette="Dark2")
```

* qualitative
* sequential
* diverging

(short codes)

```{python}

# p + scale_color_hue(=280 / 360, 1, .5)
```

```{python}
(
    p
    + scale_color_manual(
        breaks=["Adelie", "Gentoo", "Chinstrap"],
        values=["blue", "orange", "green"]
    )
)
```

## Setting alpha transparency

## Ordering levels

## Grouping levels
````

## File: guide/scale-misc.qmd
````
---
title: Scale linetype, shapes, sizes
jupyter: python3
---

* linetype and shape tend to be simple 
* size supports a range of scale types
* refer to aesthetics specification

## Linetype: specifying values

```{python}
import pandas as pd

from plotnine import *

df = pd.DataFrame(
    {
        "group": ["A"] * 2 + ["B"] * 2,
        "condition": ["treatment", "control"] * 2,
        "measure": [3, 1, 2, 1],
    }
)
```

```{python}
# | layout-nrow: 1
p = (
    ggplot(df, aes("condition", "measure", group="group"))
    + geom_line(aes(linetype="group"), size=1)
    + geom_point(aes(fill="group", shape="group"), size=4)
)

p
p + scale_linetype_manual(breaks=["A", "B"], values=["dotted", "dashdot"])
```

## Shape: specifying values

```{python}
# | layout-nrow: 1
p = (
    ggplot(df, aes("condition", "measure", group="group"))
    + geom_line(aes(linetype="group"), size=1)
    + geom_point(aes(fill="group", shape="group"), size=4)
)

p
p + scale_shape_manual(breaks=["A", "B"], values=["s", "o"])
```

## Size: choosing a style


```{python}
# | layout-nrow: 1
p = (
    ggplot(df, aes("condition", "measure", group="group", size="measure"))
    + geom_point(aes(size="measure"))
)

p + scale_size_radius()
p + scale_size_area()

```
````

## File: guide/scale-x-and-y.qmd
````
---
title: Scale x and y
jupyter: python3
---

* continuous
* discrete
* date, datetime, timedelta
* log10, sqrt, symlog
* reverse

Common formatting:

* percentages
* dates

```{python}
from plotnine import *
from plotnine.data import economics

p = ggplot(economics, aes("date", "psavert")) + geom_line()
```

## Full example

```{python}
from mizani.labels import percent_format

(
    ggplot(economics, aes("date", "psavert"))
    + geom_line()
    + labs(title="")
    + scale_y_continuous(
        name="Personal savings rate",
        limits=[0, None],
        labels=percent_format(scale=1),
    )
    + scale_x_date(
        name="Date",
        date_breaks="10 years",
        date_minor_breaks="5 year",
    )
)
```

## Expanding limits to include zero

```{python}
p + scale_y_continuous(limits=[0, None])
```

## Labelling percentages

```{python}
(
    ggplot(economics, aes("date", "psavert"))
    + geom_line()
    + scale_y_continuous(labels=lambda arr: [f"{x}%" for x in arr])
)
```

```{python}
from mizani.labels import percent_format

(
    ggplot(economics, aes("date", "psavert"))
    + geom_line()
    + scale_y_continuous(labels=percent_format(scale=1))
)
```

## Specifying date breaks

```{python}
(
    ggplot(economics, aes("date", "psavert"))
    + geom_line()
    + scale_x_date(date_breaks="10 years", date_minor_breaks="5 year")
)
```

## Applying log scale

```{python}
# | layout-nrow: 1
p = ggplot(economics, aes("date", "pce")) + geom_line()

p
p + scale_y_log10()
```
````

## File: guide/shortcuts.qmd
````
---
title: Shortcut functions
jupyter: python3
---

```{python}
from plotnine import *
from plotnine.data import mpg
```

## labs() for titles, scale names

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point()
    + scale_x_continuous(name="Engine displacement (litres)")
    + scale_y_continuous(name="Highway miles per gallon")
    + scale_color_discrete(name="Car class")
)
```

```{python}
(
    ggplot(mpg, aes("displ", "hwy", color="class"))
    + geom_point()
    + labs(
        title="Use labs() to quickly set labels",
        x="Engine displacement (litres)",
        y="Highway miles per gallon",
        color="Car class"
    )
)
```

## lims() for scale limits

## expand_limits() for data-based limits

* ref coord_cartesion, scale limits argument, xlim, ylim

## annotate() for quick plot text
````

## File: guide/themes-basics.qmd
````
---
title: Theme basics
execute:
  # disable warnings for missing values in penguins dataset
  warning: false
---

The `theme()` function customizes the style of plot elements---like the background color, grid lines, tick mark length, and much more. Premade themes like `theme_minimal()` and `theme_538()` allow for quick theming.

:::{.callout-tip title="You will learn"}
* How to customize the appearance of plots with themes.
* How to set `theme()` arguments with the `element_*()` functions.
* How to identify the 5 main areas themes are divided into.
* How to create a reusable, custom theme.
:::

:::{.callout-note title="Key points" collapse="true"}
* The 5 main areas of a plot are axis, legend, panel, plot, and strip.
* Use `element_text()` to customize pieces like axis text.
* Use `element_line()` to customize pieces like tick marks.
* Use `element_blank()` to remove theme elements from a plot.
* `theme()` arguments like `axis_text=...` set the default for y- and x-axis text. 
* Assign a `theme()` result to a variable to reuse it across plots.
::: 

## Setup

```{python}
from plotnine import *
from plotnine.data import penguins
```

## Premade themes

The quickest way to explore themes is by applying a premade one.
These start with `theme_*()`, and include `theme_minimal()`, `theme_bw()`, and `theme_538()`.

```{python}
# | layout-ncol: 2
p = (
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g", color="species"))
    + labs(title="Penguins (538 Theme)", subtitle="Very cool")
    + geom_point()
)

p
p + theme_538()
```


## Basic `theme()` use

Use the `theme()` function to customize many aspects of a plot's appearance. This function often takes an element object, like `element_text()`, which specifies properties like font size and color.

For example, the code below sets the x-axis text to be purple and rotated 90 degrees.

```{python}
(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g"))
    + geom_point()
    + theme(
        axis_text_x=element_text(angle=90, color="purple"),
    )
)
```

The `element_line()` function can be used to customize pieces like tick marks. This is shown below.

```{python}
(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g"))
    + geom_point()
    + theme(
        axis_ticks_major_y=element_line(color="red", size=5),
        axis_ticks_length_major_y=10,
    )
)
```


## Five main theme areas

There are five main areas of a plot that can be customized---axis, legend, panel, plot, and strip. These are colored in the plot below.

```{python}
(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g", shape="species"))
    + geom_point()
    + facet_wrap("~species")
    + theme(
        axis_title=element_text(size=20, color="purple"),
        legend_background=element_rect(fill="lightblue"),
        panel_background=element_rect(fill="lightgreen"),
        plot_background=element_rect(fill="lightyellow"),
        strip_background=element_rect(fill="lightpink"),
    )
    + theme()
)
```

Each of these areas contains many specific pieces that can be customized. For example, the legend margin, panel grid lines, or plot title style. There are over 100 theme arguments available in `theme()`!

## Blanking elements

Use `element_blank()` to remove theme elements from a plot.

The code below removes the x- and y-axis text and tick marks.

```{python}
(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g"))
    + geom_point()
    + theme(
        axis_text=element_blank(),
        axis_ticks=element_blank(),
    )
)
```

## Inherited elements

Some arguments like `theme(axis_text=...)` set the default for multiple pieces (in this case `axis_text_x` and `axis_text_y`). For example, the code below blanks out the x- and y-axis text by default, but then sets the x-axis text to be purple.

```{python}
(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g"))
    + geom_point()
    + theme(
        axis_text=element_blank(),
        axis_text_x=element_text(angle=90, color="purple"),
    )
)
```

## Creating a custom theme

### Using a variable

Save the result of `theme()` to a variable to reuse it across plots.

```{python}
my_theme = theme(
    panel_background=element_rect(fill="white"),
    panel_grid_major=element_line(color="#F0F0F0"),
)

(
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g"))
    + geom_point()
    + my_theme
)
```

### Subclassing premade themes

Note that many premade classes use a convenient `base_size=` argument, to apply a base size to many text elements. Sometimes it's useful to subclass these premades, and then add your own customizations.

```{python}
# | layout-ncol: 2
class custom_theme(theme_gray):
    def __init__(self, base_size=11, base_family=None):
        super().__init__(base_size=base_size, base_family=base_family)
        self += theme(axis_text_x=element_text(angle=90, color="purple"))


p = ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g")) + geom_point()

p + custom_theme()
p + custom_theme(base_size=24)
```
````

## File: guide/themes-custom.qmd
````
---
title: Custom themes
---


* custom themes
  - axis
    - area: title, text, ticks, minor.ticks 
    - sub-area: length
    - loc: x[.top, bottom, left, right]
  - legend
    - area: spacing, key, ticks, axis, text, title, position, box
    - big attr: background, margin, frame, direction, byrow, location
    - sub attr:
      - x, y
      - size, height, width
      - top, bottom, right, left, inside
      - just, margin, background, spacing

  - panel
    - area: spacing, grid
    - attrs: background, border, ontop
  - plot
    - area: title, subtitle, caption, tag
    - attrs: background, position, location
  - strip
    - area: background, text
    - attrs:
      - x, y
      - bottom, top
      - left, right
      - switch.pad.grid
      - switch.pad.wrap

  - complete, validate
````

## File: guide/themes-premade.qmd
````
---
title: Premade themes
jupyter: python3
execute:
  # disable warnings for missing values in penguins dataset
  warning: false
---

Premade themes begin with `theme_*()`. For convenience, this page displays 10 premade themes that come with `plotnine`. By default, `plotnine` uses `theme_gray()`.

## Setup


```{python}
from plotnine import *
from plotnine.data import penguins

p = (
    ggplot(penguins, aes(x="flipper_length_mm", y="body_mass_g", color="species"))
    + geom_point()
    + scale_x_continuous(breaks=range(150, 250, 30))
    + facet_wrap("~species")
    + labs(subtitle="I am a subtitle")
)
```

## BW

```{python}
p + theme_bw() + labs(title="theme_bw()")
```

## Classical

```{python}
p + theme_classic() + labs(title="theme_classic()")
```

## Gray

```{python}
p + theme_gray() + labs(title="theme_gray()")
```

## Light/Dark

```{python}
# | layout-ncol: 2
p + theme_light() + labs(title="theme_light()")
p + theme_dark() + labs(title="theme_dark()")
```

## Matplotlib

```{python}
p + theme_matplotlib() + labs(title="theme_matplotlib()")
```

## Minimal

```{python}
p + theme_minimal() + labs(title="theme_minimal()")
```

## Seaborn

```{python}
p + theme_seaborn() + labs(title="theme_seaborn()")
```

## Tufte

```{python}
p + theme_tufte() + labs(title="theme_tufte()")
```

## 538

```{python}
p + theme_538() + labs(title="theme_538()")
```
````
