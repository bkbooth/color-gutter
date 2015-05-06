# Color Gutter for Atom.io

**NOTICE:** I've just unpublished this package from `apm` (07/05/2015). There's a couple of outstanding bugs and there appears to be a memory leak with this package too. I don't use atom as my primary editor and I don't have time to prioritise fixing this. If you have time and interest, feel free to fork and re-publish under your name.

Show colour swatches in the gutter.

![Color Gutter Preview](https://raw.githubusercontent.com/bkbooth/color-gutter/master/preview.gif)

### What does it do?

* Find known colour definition patterns and display a swatch preview of the colour in the gutter
* Currently supports the following colour patterns:
  * Hex (eg. `#fff` and `#65f8e2`)
  * RGBa (eg. `rgb(0, 218, 159)`, `rgb(0%, 50%, 100%)`, `rgba(165, 225, 230, .8)`)
  * HSLa (eg. `hsl(52, 100%, 64%)`, `hsla(4, 100%, 59%, 0.6)`)

### What doesn't it do?
* Support Sass and LESS variables and functions (yet)
* Allow you to modify colours (I may look into this in the future,
  but [color-picker](https://atom.io/packages/color-picker) already does a great job)
* Make you pancakes for breakfast

**Note:** I natively speak UK English so I know it should be 'Colour Gutter', I used to
argue for spelling it 'colour' in all variables and functions, but US English has become the
language of developers. There's no point having a bunch of variables and functions spelt 'colour'
when all the libraries we use spell it 'color', confusion would rein.
