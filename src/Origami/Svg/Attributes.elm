module Origami.Svg.Attributes exposing
    ( css, fromSvgAttribute, batchAttributes
    , accentHeight, accelerate, accumulate, additive, alphabetic, allowReorder
    , amplitude, arabicForm, ascent, attributeName, attributeType, autoReverse
    , azimuth, baseFrequency, baseProfile, bbox, begin, bias, by, calcMode
    , capHeight, class, clipPathUnits, contentScriptType, contentStyleType, cx, cy
    , d, decelerate, descent, diffuseConstant, divisor, dur, dx, dy, edgeMode
    , elevation, end, exponent, externalResourcesRequired, filterRes, filterUnits
    , format, from, fx, fy, g1, g2, glyphName, glyphRef, gradientTransform
    , gradientUnits, hanging, height, horizAdvX, horizOriginX, horizOriginY, id
    , ideographic, in_, in2, intercept, k, k1, k2, k3, k4, kernelMatrix
    , kernelUnitLength, keyPoints, keySplines, keyTimes, lang, lengthAdjust
    , limitingConeAngle, local, markerHeight, markerUnits, markerWidth
    , maskContentUnits, maskUnits, mathematical, max, media, method, min, mode
    , name, numOctaves, offset, operator, order, orient, orientation, origin
    , overlinePosition, overlineThickness, panose1, path, pathLength
    , patternContentUnits, patternTransform, patternUnits, pointOrder, points
    , pointsAtX, pointsAtY, pointsAtZ, preserveAlpha, preserveAspectRatio
    , primitiveUnits, r, radius, refX, refY, renderingIntent, repeatCount
    , repeatDur, requiredExtensions, requiredFeatures, restart, result, rotate
    , rx, ry, scale, seed, slope, spacing, specularConstant, specularExponent
    , speed, spreadMethod, startOffset, stdDeviation, stemh, stemv, stitchTiles
    , strikethroughPosition, strikethroughThickness, string, style, surfaceScale
    , systemLanguage, tableValues, target, targetX, targetY, textLength, title, to
    , transform, type_, u1, u2, underlinePosition, underlineThickness, unicode
    , unicodeRange, unitsPerEm, vAlphabetic, vHanging, vIdeographic, vMathematical
    , values, version, vertAdvY, vertOriginX, vertOriginY, viewBox, viewTarget
    , width, widths, x, xHeight, x1, x2, xChannelSelector, xlinkActuate
    , xlinkArcrole, xlinkHref, xlinkRole, xlinkShow, xlinkTitle, xlinkType
    , xmlBase, xmlLang, xmlSpace, y, y1, y2, yChannelSelector, z, zoomAndPan
    , alignmentBaseline, baselineShift, clipPath, clipRule, clip
    , colorInterpolationFilters, colorInterpolation, colorProfile, colorRendering
    , color, cursor, direction, display, dominantBaseline, enableBackground
    , fillOpacity, fillRule, fill, filter, floodColor, floodOpacity, fontFamily
    , fontSizeAdjust, fontSize, fontStretch, fontStyle, fontVariant, fontWeight
    , glyphOrientationHorizontal, glyphOrientationVertical, imageRendering
    , kerning, letterSpacing, lightingColor, markerEnd, markerMid, markerStart
    , mask, opacity, overflow, pointerEvents, shapeRendering, stopColor
    , stopOpacity, strokeDasharray, strokeDashoffset, strokeLinecap
    , strokeLinejoin, strokeMiterlimit, strokeOpacity, strokeWidth, stroke
    , textAnchor, textDecoration, textRendering, unicodeBidi, visibility
    , wordSpacing, writingMode
    )

{-| Drop-in replacement for the `Svg.Attributes` module from the `elm/svg` package.
The only functions added are `css`, `fromSvgAttribute` and `batchAttributes`:

@docs css, fromSvgAttribute, batchAttributes


# Regular attributes

@docs accentHeight, accelerate, accumulate, additive, alphabetic, allowReorder
@docs amplitude, arabicForm, ascent, attributeName, attributeType, autoReverse
@docs azimuth, baseFrequency, baseProfile, bbox, begin, bias, by, calcMode
@docs capHeight, class, clipPathUnits, contentScriptType, contentStyleType, cx, cy
@docs d, decelerate, descent, diffuseConstant, divisor, dur, dx, dy, edgeMode
@docs elevation, end, exponent, externalResourcesRequired, filterRes, filterUnits
@docs format, from, fx, fy, g1, g2, glyphName, glyphRef, gradientTransform
@docs gradientUnits, hanging, height, horizAdvX, horizOriginX, horizOriginY, id
@docs ideographic, in_, in2, intercept, k, k1, k2, k3, k4, kernelMatrix
@docs kernelUnitLength, keyPoints, keySplines, keyTimes, lang, lengthAdjust
@docs limitingConeAngle, local, markerHeight, markerUnits, markerWidth
@docs maskContentUnits, maskUnits, mathematical, max, media, method, min, mode
@docs name, numOctaves, offset, operator, order, orient, orientation, origin
@docs overlinePosition, overlineThickness, panose1, path, pathLength
@docs patternContentUnits, patternTransform, patternUnits, pointOrder, points
@docs pointsAtX, pointsAtY, pointsAtZ, preserveAlpha, preserveAspectRatio
@docs primitiveUnits, r, radius, refX, refY, renderingIntent, repeatCount
@docs repeatDur, requiredExtensions, requiredFeatures, restart, result, rotate
@docs rx, ry, scale, seed, slope, spacing, specularConstant, specularExponent
@docs speed, spreadMethod, startOffset, stdDeviation, stemh, stemv, stitchTiles
@docs strikethroughPosition, strikethroughThickness, string, style, surfaceScale
@docs systemLanguage, tableValues, target, targetX, targetY, textLength, title, to
@docs transform, type_, u1, u2, underlinePosition, underlineThickness, unicode
@docs unicodeRange, unitsPerEm, vAlphabetic, vHanging, vIdeographic, vMathematical
@docs values, version, vertAdvY, vertOriginX, vertOriginY, viewBox, viewTarget
@docs width, widths, x, xHeight, x1, x2, xChannelSelector, xlinkActuate
@docs xlinkArcrole, xlinkHref, xlinkRole, xlinkShow, xlinkTitle, xlinkType
@docs xmlBase, xmlLang, xmlSpace, y, y1, y2, yChannelSelector, z, zoomAndPan


# Presentation attributes

@docs alignmentBaseline, baselineShift, clipPath, clipRule, clip
@docs colorInterpolationFilters, colorInterpolation, colorProfile, colorRendering
@docs color, cursor, direction, display, dominantBaseline, enableBackground
@docs fillOpacity, fillRule, fill, filter, floodColor, floodOpacity, fontFamily
@docs fontSizeAdjust, fontSize, fontStretch, fontStyle, fontVariant, fontWeight
@docs glyphOrientationHorizontal, glyphOrientationVertical, imageRendering
@docs kerning, letterSpacing, lightingColor, markerEnd, markerMid, markerStart
@docs mask, opacity, overflow, pointerEvents, shapeRendering, stopColor
@docs stopOpacity, strokeDasharray, strokeDashoffset, strokeLinecap
@docs strokeLinejoin, strokeMiterlimit, strokeOpacity, strokeWidth, stroke
@docs textAnchor, textDecoration, textRendering, unicodeBidi, visibility
@docs wordSpacing, writingMode

-}

import Origami exposing (Style)
import Origami.Svg exposing (Attribute)
import Origami.VirtualDom
import VirtualDom


{-| Apply styles to an element.

See the [`Origami` module documentation](http://package.elm-lang.org/packages/miyamoen/elm-origami/latest/Origami) for an overview of how to use this function.

-}
css : List Style -> Attribute msg
css =
    Origami.VirtualDom.css


{-| -}
fromSvgAttribute : VirtualDom.Attribute msg -> Attribute msg
fromSvgAttribute =
    Origami.VirtualDom.plainAttribute


{-| Batch Attributes.
-}
batchAttributes : List (Attribute msg) -> Attribute msg
batchAttributes =
    Origami.VirtualDom.batchAttributes



-- REGULAR ATTRIBUTES


{-| -}
accentHeight : String -> Attribute msg
accentHeight =
    Origami.VirtualDom.attribute "accent-height"


{-| -}
accelerate : String -> Attribute msg
accelerate =
    Origami.VirtualDom.attribute "accelerate"


{-| -}
accumulate : String -> Attribute msg
accumulate =
    Origami.VirtualDom.attribute "accumulate"


{-| -}
additive : String -> Attribute msg
additive =
    Origami.VirtualDom.attribute "additive"


{-| -}
alphabetic : String -> Attribute msg
alphabetic =
    Origami.VirtualDom.attribute "alphabetic"


{-| -}
allowReorder : String -> Attribute msg
allowReorder =
    Origami.VirtualDom.attribute "allowReorder"


{-| -}
amplitude : String -> Attribute msg
amplitude =
    Origami.VirtualDom.attribute "amplitude"


{-| -}
arabicForm : String -> Attribute msg
arabicForm =
    Origami.VirtualDom.attribute "arabic-form"


{-| -}
ascent : String -> Attribute msg
ascent =
    Origami.VirtualDom.attribute "ascent"


{-| -}
attributeName : String -> Attribute msg
attributeName =
    Origami.VirtualDom.attribute "attributeName"


{-| -}
attributeType : String -> Attribute msg
attributeType =
    Origami.VirtualDom.attribute "attributeType"


{-| -}
autoReverse : String -> Attribute msg
autoReverse =
    Origami.VirtualDom.attribute "autoReverse"


{-| -}
azimuth : String -> Attribute msg
azimuth =
    Origami.VirtualDom.attribute "azimuth"


{-| -}
baseFrequency : String -> Attribute msg
baseFrequency =
    Origami.VirtualDom.attribute "baseFrequency"


{-| -}
baseProfile : String -> Attribute msg
baseProfile =
    Origami.VirtualDom.attribute "baseProfile"


{-| -}
bbox : String -> Attribute msg
bbox =
    Origami.VirtualDom.attribute "bbox"


{-| -}
begin : String -> Attribute msg
begin =
    Origami.VirtualDom.attribute "begin"


{-| -}
bias : String -> Attribute msg
bias =
    Origami.VirtualDom.attribute "bias"


{-| -}
by : String -> Attribute msg
by value =
    Origami.VirtualDom.attribute "by" value


{-| -}
calcMode : String -> Attribute msg
calcMode =
    Origami.VirtualDom.attribute "calcMode"


{-| -}
capHeight : String -> Attribute msg
capHeight =
    Origami.VirtualDom.attribute "cap-height"


{-| -}
class : String -> Attribute msg
class =
    Origami.VirtualDom.attribute "class"


{-| -}
clipPathUnits : String -> Attribute msg
clipPathUnits =
    Origami.VirtualDom.attribute "clipPathUnits"


{-| -}
contentScriptType : String -> Attribute msg
contentScriptType =
    Origami.VirtualDom.attribute "contentScriptType"


{-| -}
contentStyleType : String -> Attribute msg
contentStyleType =
    Origami.VirtualDom.attribute "contentStyleType"


{-| -}
cx : String -> Attribute msg
cx =
    Origami.VirtualDom.attribute "cx"


{-| -}
cy : String -> Attribute msg
cy =
    Origami.VirtualDom.attribute "cy"


{-| -}
d : String -> Attribute msg
d =
    Origami.VirtualDom.attribute "d"


{-| -}
decelerate : String -> Attribute msg
decelerate =
    Origami.VirtualDom.attribute "decelerate"


{-| -}
descent : String -> Attribute msg
descent =
    Origami.VirtualDom.attribute "descent"


{-| -}
diffuseConstant : String -> Attribute msg
diffuseConstant =
    Origami.VirtualDom.attribute "diffuseConstant"


{-| -}
divisor : String -> Attribute msg
divisor =
    Origami.VirtualDom.attribute "divisor"


{-| -}
dur : String -> Attribute msg
dur =
    Origami.VirtualDom.attribute "dur"


{-| -}
dx : String -> Attribute msg
dx =
    Origami.VirtualDom.attribute "dx"


{-| -}
dy : String -> Attribute msg
dy =
    Origami.VirtualDom.attribute "dy"


{-| -}
edgeMode : String -> Attribute msg
edgeMode =
    Origami.VirtualDom.attribute "edgeMode"


{-| -}
elevation : String -> Attribute msg
elevation =
    Origami.VirtualDom.attribute "elevation"


{-| -}
end : String -> Attribute msg
end =
    Origami.VirtualDom.attribute "end"


{-| -}
exponent : String -> Attribute msg
exponent =
    Origami.VirtualDom.attribute "exponent"


{-| -}
externalResourcesRequired : String -> Attribute msg
externalResourcesRequired =
    Origami.VirtualDom.attribute "externalResourcesRequired"


{-| -}
filterRes : String -> Attribute msg
filterRes =
    Origami.VirtualDom.attribute "filterRes"


{-| -}
filterUnits : String -> Attribute msg
filterUnits =
    Origami.VirtualDom.attribute "filterUnits"


{-| -}
format : String -> Attribute msg
format =
    Origami.VirtualDom.attribute "format"


{-| -}
from : String -> Attribute msg
from value =
    Origami.VirtualDom.attribute "from" value


{-| -}
fx : String -> Attribute msg
fx =
    Origami.VirtualDom.attribute "fx"


{-| -}
fy : String -> Attribute msg
fy =
    Origami.VirtualDom.attribute "fy"


{-| -}
g1 : String -> Attribute msg
g1 =
    Origami.VirtualDom.attribute "g1"


{-| -}
g2 : String -> Attribute msg
g2 =
    Origami.VirtualDom.attribute "g2"


{-| -}
glyphName : String -> Attribute msg
glyphName =
    Origami.VirtualDom.attribute "glyph-name"


{-| -}
glyphRef : String -> Attribute msg
glyphRef =
    Origami.VirtualDom.attribute "glyphRef"


{-| -}
gradientTransform : String -> Attribute msg
gradientTransform =
    Origami.VirtualDom.attribute "gradientTransform"


{-| -}
gradientUnits : String -> Attribute msg
gradientUnits =
    Origami.VirtualDom.attribute "gradientUnits"


{-| -}
hanging : String -> Attribute msg
hanging =
    Origami.VirtualDom.attribute "hanging"


{-| -}
height : String -> Attribute msg
height =
    Origami.VirtualDom.attribute "height"


{-| -}
horizAdvX : String -> Attribute msg
horizAdvX =
    Origami.VirtualDom.attribute "horiz-adv-x"


{-| -}
horizOriginX : String -> Attribute msg
horizOriginX =
    Origami.VirtualDom.attribute "horiz-origin-x"


{-| -}
horizOriginY : String -> Attribute msg
horizOriginY =
    Origami.VirtualDom.attribute "horiz-origin-y"


{-| -}
id : String -> Attribute msg
id =
    Origami.VirtualDom.attribute "id"


{-| -}
ideographic : String -> Attribute msg
ideographic =
    Origami.VirtualDom.attribute "ideographic"


{-| -}
in_ : String -> Attribute msg
in_ =
    Origami.VirtualDom.attribute "in"


{-| -}
in2 : String -> Attribute msg
in2 =
    Origami.VirtualDom.attribute "in2"


{-| -}
intercept : String -> Attribute msg
intercept =
    Origami.VirtualDom.attribute "intercept"


{-| -}
k : String -> Attribute msg
k =
    Origami.VirtualDom.attribute "k"


{-| -}
k1 : String -> Attribute msg
k1 =
    Origami.VirtualDom.attribute "k1"


{-| -}
k2 : String -> Attribute msg
k2 =
    Origami.VirtualDom.attribute "k2"


{-| -}
k3 : String -> Attribute msg
k3 =
    Origami.VirtualDom.attribute "k3"


{-| -}
k4 : String -> Attribute msg
k4 =
    Origami.VirtualDom.attribute "k4"


{-| -}
kernelMatrix : String -> Attribute msg
kernelMatrix =
    Origami.VirtualDom.attribute "kernelMatrix"


{-| -}
kernelUnitLength : String -> Attribute msg
kernelUnitLength =
    Origami.VirtualDom.attribute "kernelUnitLength"


{-| -}
keyPoints : String -> Attribute msg
keyPoints =
    Origami.VirtualDom.attribute "keyPoints"


{-| -}
keySplines : String -> Attribute msg
keySplines =
    Origami.VirtualDom.attribute "keySplines"


{-| -}
keyTimes : String -> Attribute msg
keyTimes =
    Origami.VirtualDom.attribute "keyTimes"


{-| -}
lang : String -> Attribute msg
lang =
    Origami.VirtualDom.attribute "lang"


{-| -}
lengthAdjust : String -> Attribute msg
lengthAdjust =
    Origami.VirtualDom.attribute "lengthAdjust"


{-| -}
limitingConeAngle : String -> Attribute msg
limitingConeAngle =
    Origami.VirtualDom.attribute "limitingConeAngle"


{-| -}
local : String -> Attribute msg
local =
    Origami.VirtualDom.attribute "local"


{-| -}
markerHeight : String -> Attribute msg
markerHeight =
    Origami.VirtualDom.attribute "markerHeight"


{-| -}
markerUnits : String -> Attribute msg
markerUnits =
    Origami.VirtualDom.attribute "markerUnits"


{-| -}
markerWidth : String -> Attribute msg
markerWidth =
    Origami.VirtualDom.attribute "markerWidth"


{-| -}
maskContentUnits : String -> Attribute msg
maskContentUnits =
    Origami.VirtualDom.attribute "maskContentUnits"


{-| -}
maskUnits : String -> Attribute msg
maskUnits =
    Origami.VirtualDom.attribute "maskUnits"


{-| -}
mathematical : String -> Attribute msg
mathematical =
    Origami.VirtualDom.attribute "mathematical"


{-| -}
max : String -> Attribute msg
max =
    Origami.VirtualDom.attribute "max"


{-| -}
media : String -> Attribute msg
media =
    Origami.VirtualDom.attribute "media"


{-| -}
method : String -> Attribute msg
method =
    Origami.VirtualDom.attribute "method"


{-| -}
min : String -> Attribute msg
min =
    Origami.VirtualDom.attribute "min"


{-| -}
mode : String -> Attribute msg
mode =
    Origami.VirtualDom.attribute "mode"


{-| -}
name : String -> Attribute msg
name =
    Origami.VirtualDom.attribute "name"


{-| -}
numOctaves : String -> Attribute msg
numOctaves =
    Origami.VirtualDom.attribute "numOctaves"


{-| -}
offset : String -> Attribute msg
offset =
    Origami.VirtualDom.attribute "offset"


{-| -}
operator : String -> Attribute msg
operator =
    Origami.VirtualDom.attribute "operator"


{-| -}
order : String -> Attribute msg
order =
    Origami.VirtualDom.attribute "order"


{-| -}
orient : String -> Attribute msg
orient =
    Origami.VirtualDom.attribute "orient"


{-| -}
orientation : String -> Attribute msg
orientation =
    Origami.VirtualDom.attribute "orientation"


{-| -}
origin : String -> Attribute msg
origin =
    Origami.VirtualDom.attribute "origin"


{-| -}
overlinePosition : String -> Attribute msg
overlinePosition =
    Origami.VirtualDom.attribute "overline-position"


{-| -}
overlineThickness : String -> Attribute msg
overlineThickness =
    Origami.VirtualDom.attribute "overline-thickness"


{-| -}
panose1 : String -> Attribute msg
panose1 =
    Origami.VirtualDom.attribute "panose-1"


{-| -}
path : String -> Attribute msg
path =
    Origami.VirtualDom.attribute "path"


{-| -}
pathLength : String -> Attribute msg
pathLength =
    Origami.VirtualDom.attribute "pathLength"


{-| -}
patternContentUnits : String -> Attribute msg
patternContentUnits =
    Origami.VirtualDom.attribute "patternContentUnits"


{-| -}
patternTransform : String -> Attribute msg
patternTransform =
    Origami.VirtualDom.attribute "patternTransform"


{-| -}
patternUnits : String -> Attribute msg
patternUnits =
    Origami.VirtualDom.attribute "patternUnits"


{-| -}
pointOrder : String -> Attribute msg
pointOrder =
    Origami.VirtualDom.attribute "point-order"


{-| -}
points : String -> Attribute msg
points =
    Origami.VirtualDom.attribute "points"


{-| -}
pointsAtX : String -> Attribute msg
pointsAtX =
    Origami.VirtualDom.attribute "pointsAtX"


{-| -}
pointsAtY : String -> Attribute msg
pointsAtY =
    Origami.VirtualDom.attribute "pointsAtY"


{-| -}
pointsAtZ : String -> Attribute msg
pointsAtZ =
    Origami.VirtualDom.attribute "pointsAtZ"


{-| -}
preserveAlpha : String -> Attribute msg
preserveAlpha =
    Origami.VirtualDom.attribute "preserveAlpha"


{-| -}
preserveAspectRatio : String -> Attribute msg
preserveAspectRatio =
    Origami.VirtualDom.attribute "preserveAspectRatio"


{-| -}
primitiveUnits : String -> Attribute msg
primitiveUnits =
    Origami.VirtualDom.attribute "primitiveUnits"


{-| -}
r : String -> Attribute msg
r =
    Origami.VirtualDom.attribute "r"


{-| -}
radius : String -> Attribute msg
radius =
    Origami.VirtualDom.attribute "radius"


{-| -}
refX : String -> Attribute msg
refX =
    Origami.VirtualDom.attribute "refX"


{-| -}
refY : String -> Attribute msg
refY =
    Origami.VirtualDom.attribute "refY"


{-| -}
renderingIntent : String -> Attribute msg
renderingIntent =
    Origami.VirtualDom.attribute "rendering-intent"


{-| -}
repeatCount : String -> Attribute msg
repeatCount =
    Origami.VirtualDom.attribute "repeatCount"


{-| -}
repeatDur : String -> Attribute msg
repeatDur =
    Origami.VirtualDom.attribute "repeatDur"


{-| -}
requiredExtensions : String -> Attribute msg
requiredExtensions =
    Origami.VirtualDom.attribute "requiredExtensions"


{-| -}
requiredFeatures : String -> Attribute msg
requiredFeatures =
    Origami.VirtualDom.attribute "requiredFeatures"


{-| -}
restart : String -> Attribute msg
restart =
    Origami.VirtualDom.attribute "restart"


{-| -}
result : String -> Attribute msg
result =
    Origami.VirtualDom.attribute "result"


{-| -}
rotate : String -> Attribute msg
rotate =
    Origami.VirtualDom.attribute "rotate"


{-| -}
rx : String -> Attribute msg
rx =
    Origami.VirtualDom.attribute "rx"


{-| -}
ry : String -> Attribute msg
ry =
    Origami.VirtualDom.attribute "ry"


{-| -}
scale : String -> Attribute msg
scale =
    Origami.VirtualDom.attribute "scale"


{-| -}
seed : String -> Attribute msg
seed =
    Origami.VirtualDom.attribute "seed"


{-| -}
slope : String -> Attribute msg
slope =
    Origami.VirtualDom.attribute "slope"


{-| -}
spacing : String -> Attribute msg
spacing =
    Origami.VirtualDom.attribute "spacing"


{-| -}
specularConstant : String -> Attribute msg
specularConstant =
    Origami.VirtualDom.attribute "specularConstant"


{-| -}
specularExponent : String -> Attribute msg
specularExponent =
    Origami.VirtualDom.attribute "specularExponent"


{-| -}
speed : String -> Attribute msg
speed =
    Origami.VirtualDom.attribute "speed"


{-| -}
spreadMethod : String -> Attribute msg
spreadMethod =
    Origami.VirtualDom.attribute "spreadMethod"


{-| -}
startOffset : String -> Attribute msg
startOffset =
    Origami.VirtualDom.attribute "startOffset"


{-| -}
stdDeviation : String -> Attribute msg
stdDeviation =
    Origami.VirtualDom.attribute "stdDeviation"


{-| -}
stemh : String -> Attribute msg
stemh =
    Origami.VirtualDom.attribute "stemh"


{-| -}
stemv : String -> Attribute msg
stemv =
    Origami.VirtualDom.attribute "stemv"


{-| -}
stitchTiles : String -> Attribute msg
stitchTiles =
    Origami.VirtualDom.attribute "stitchTiles"


{-| -}
strikethroughPosition : String -> Attribute msg
strikethroughPosition =
    Origami.VirtualDom.attribute "strikethrough-position"


{-| -}
strikethroughThickness : String -> Attribute msg
strikethroughThickness =
    Origami.VirtualDom.attribute "strikethrough-thickness"


{-| -}
string : String -> Attribute msg
string =
    Origami.VirtualDom.attribute "string"


{-| -}
style : String -> Attribute msg
style =
    Origami.VirtualDom.attribute "style"


{-| -}
surfaceScale : String -> Attribute msg
surfaceScale =
    Origami.VirtualDom.attribute "surfaceScale"


{-| -}
systemLanguage : String -> Attribute msg
systemLanguage =
    Origami.VirtualDom.attribute "systemLanguage"


{-| -}
tableValues : String -> Attribute msg
tableValues =
    Origami.VirtualDom.attribute "tableValues"


{-| -}
target : String -> Attribute msg
target =
    Origami.VirtualDom.attribute "target"


{-| -}
targetX : String -> Attribute msg
targetX =
    Origami.VirtualDom.attribute "targetX"


{-| -}
targetY : String -> Attribute msg
targetY =
    Origami.VirtualDom.attribute "targetY"


{-| -}
textLength : String -> Attribute msg
textLength =
    Origami.VirtualDom.attribute "textLength"


{-| -}
title : String -> Attribute msg
title =
    Origami.VirtualDom.attribute "title"


{-| -}
to : String -> Attribute msg
to value =
    Origami.VirtualDom.attribute "to" value


{-| -}
transform : String -> Attribute msg
transform =
    Origami.VirtualDom.attribute "transform"


{-| -}
type_ : String -> Attribute msg
type_ =
    Origami.VirtualDom.attribute "type"


{-| -}
u1 : String -> Attribute msg
u1 =
    Origami.VirtualDom.attribute "u1"


{-| -}
u2 : String -> Attribute msg
u2 =
    Origami.VirtualDom.attribute "u2"


{-| -}
underlinePosition : String -> Attribute msg
underlinePosition =
    Origami.VirtualDom.attribute "underline-position"


{-| -}
underlineThickness : String -> Attribute msg
underlineThickness =
    Origami.VirtualDom.attribute "underline-thickness"


{-| -}
unicode : String -> Attribute msg
unicode =
    Origami.VirtualDom.attribute "unicode"


{-| -}
unicodeRange : String -> Attribute msg
unicodeRange =
    Origami.VirtualDom.attribute "unicode-range"


{-| -}
unitsPerEm : String -> Attribute msg
unitsPerEm =
    Origami.VirtualDom.attribute "units-per-em"


{-| -}
vAlphabetic : String -> Attribute msg
vAlphabetic =
    Origami.VirtualDom.attribute "v-alphabetic"


{-| -}
vHanging : String -> Attribute msg
vHanging =
    Origami.VirtualDom.attribute "v-hanging"


{-| -}
vIdeographic : String -> Attribute msg
vIdeographic =
    Origami.VirtualDom.attribute "v-ideographic"


{-| -}
vMathematical : String -> Attribute msg
vMathematical =
    Origami.VirtualDom.attribute "v-mathematical"


{-| -}
values : String -> Attribute msg
values value =
    Origami.VirtualDom.attribute "values" value


{-| -}
version : String -> Attribute msg
version =
    Origami.VirtualDom.attribute "version"


{-| -}
vertAdvY : String -> Attribute msg
vertAdvY =
    Origami.VirtualDom.attribute "vert-adv-y"


{-| -}
vertOriginX : String -> Attribute msg
vertOriginX =
    Origami.VirtualDom.attribute "vert-origin-x"


{-| -}
vertOriginY : String -> Attribute msg
vertOriginY =
    Origami.VirtualDom.attribute "vert-origin-y"


{-| -}
viewBox : String -> Attribute msg
viewBox =
    Origami.VirtualDom.attribute "viewBox"


{-| -}
viewTarget : String -> Attribute msg
viewTarget =
    Origami.VirtualDom.attribute "viewTarget"


{-| -}
width : String -> Attribute msg
width =
    Origami.VirtualDom.attribute "width"


{-| -}
widths : String -> Attribute msg
widths =
    Origami.VirtualDom.attribute "widths"


{-| -}
x : String -> Attribute msg
x =
    Origami.VirtualDom.attribute "x"


{-| -}
xHeight : String -> Attribute msg
xHeight =
    Origami.VirtualDom.attribute "x-height"


{-| -}
x1 : String -> Attribute msg
x1 =
    Origami.VirtualDom.attribute "x1"


{-| -}
x2 : String -> Attribute msg
x2 =
    Origami.VirtualDom.attribute "x2"


{-| -}
xChannelSelector : String -> Attribute msg
xChannelSelector =
    Origami.VirtualDom.attribute "xChannelSelector"


{-| -}
xlinkActuate : String -> Attribute msg
xlinkActuate =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:actuate"


{-| -}
xlinkArcrole : String -> Attribute msg
xlinkArcrole =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:arcrole"


{-| -}
xlinkHref : String -> Attribute msg
xlinkHref value =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:href" value


{-| -}
xlinkRole : String -> Attribute msg
xlinkRole =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:role"


{-| -}
xlinkShow : String -> Attribute msg
xlinkShow =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:show"


{-| -}
xlinkTitle : String -> Attribute msg
xlinkTitle =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:title"


{-| -}
xlinkType : String -> Attribute msg
xlinkType =
    Origami.VirtualDom.attributeNS "http://www.w3.org/1999/xlink" "xlink:type"


{-| -}
xmlBase : String -> Attribute msg
xmlBase =
    Origami.VirtualDom.attributeNS "http://www.w3.org/XML/1998/namespace" "xml:base"


{-| -}
xmlLang : String -> Attribute msg
xmlLang =
    Origami.VirtualDom.attributeNS "http://www.w3.org/XML/1998/namespace" "xml:lang"


{-| -}
xmlSpace : String -> Attribute msg
xmlSpace =
    Origami.VirtualDom.attributeNS "http://www.w3.org/XML/1998/namespace" "xml:space"


{-| -}
y : String -> Attribute msg
y =
    Origami.VirtualDom.attribute "y"


{-| -}
y1 : String -> Attribute msg
y1 =
    Origami.VirtualDom.attribute "y1"


{-| -}
y2 : String -> Attribute msg
y2 =
    Origami.VirtualDom.attribute "y2"


{-| -}
yChannelSelector : String -> Attribute msg
yChannelSelector =
    Origami.VirtualDom.attribute "yChannelSelector"


{-| -}
z : String -> Attribute msg
z =
    Origami.VirtualDom.attribute "z"


{-| -}
zoomAndPan : String -> Attribute msg
zoomAndPan =
    Origami.VirtualDom.attribute "zoomAndPan"



-- PRESENTATION ATTRIBUTES


{-| -}
alignmentBaseline : String -> Attribute msg
alignmentBaseline =
    Origami.VirtualDom.attribute "alignment-baseline"


{-| -}
baselineShift : String -> Attribute msg
baselineShift =
    Origami.VirtualDom.attribute "baseline-shift"


{-| -}
clipPath : String -> Attribute msg
clipPath =
    Origami.VirtualDom.attribute "clip-path"


{-| -}
clipRule : String -> Attribute msg
clipRule =
    Origami.VirtualDom.attribute "clip-rule"


{-| -}
clip : String -> Attribute msg
clip =
    Origami.VirtualDom.attribute "clip"


{-| -}
colorInterpolationFilters : String -> Attribute msg
colorInterpolationFilters =
    Origami.VirtualDom.attribute "color-interpolation-filters"


{-| -}
colorInterpolation : String -> Attribute msg
colorInterpolation =
    Origami.VirtualDom.attribute "color-interpolation"


{-| -}
colorProfile : String -> Attribute msg
colorProfile =
    Origami.VirtualDom.attribute "color-profile"


{-| -}
colorRendering : String -> Attribute msg
colorRendering =
    Origami.VirtualDom.attribute "color-rendering"


{-| -}
color : String -> Attribute msg
color =
    Origami.VirtualDom.attribute "color"


{-| -}
cursor : String -> Attribute msg
cursor =
    Origami.VirtualDom.attribute "cursor"


{-| -}
direction : String -> Attribute msg
direction =
    Origami.VirtualDom.attribute "direction"


{-| -}
display : String -> Attribute msg
display =
    Origami.VirtualDom.attribute "display"


{-| -}
dominantBaseline : String -> Attribute msg
dominantBaseline =
    Origami.VirtualDom.attribute "dominant-baseline"


{-| -}
enableBackground : String -> Attribute msg
enableBackground =
    Origami.VirtualDom.attribute "enable-background"


{-| -}
fillOpacity : String -> Attribute msg
fillOpacity =
    Origami.VirtualDom.attribute "fill-opacity"


{-| -}
fillRule : String -> Attribute msg
fillRule =
    Origami.VirtualDom.attribute "fill-rule"


{-| -}
fill : String -> Attribute msg
fill =
    Origami.VirtualDom.attribute "fill"


{-| -}
filter : String -> Attribute msg
filter =
    Origami.VirtualDom.attribute "filter"


{-| -}
floodColor : String -> Attribute msg
floodColor =
    Origami.VirtualDom.attribute "flood-color"


{-| -}
floodOpacity : String -> Attribute msg
floodOpacity =
    Origami.VirtualDom.attribute "flood-opacity"


{-| -}
fontFamily : String -> Attribute msg
fontFamily =
    Origami.VirtualDom.attribute "font-family"


{-| -}
fontSizeAdjust : String -> Attribute msg
fontSizeAdjust =
    Origami.VirtualDom.attribute "font-size-adjust"


{-| -}
fontSize : String -> Attribute msg
fontSize =
    Origami.VirtualDom.attribute "font-size"


{-| -}
fontStretch : String -> Attribute msg
fontStretch =
    Origami.VirtualDom.attribute "font-stretch"


{-| -}
fontStyle : String -> Attribute msg
fontStyle =
    Origami.VirtualDom.attribute "font-style"


{-| -}
fontVariant : String -> Attribute msg
fontVariant =
    Origami.VirtualDom.attribute "font-variant"


{-| -}
fontWeight : String -> Attribute msg
fontWeight =
    Origami.VirtualDom.attribute "font-weight"


{-| -}
glyphOrientationHorizontal : String -> Attribute msg
glyphOrientationHorizontal =
    Origami.VirtualDom.attribute "glyph-orientation-horizontal"


{-| -}
glyphOrientationVertical : String -> Attribute msg
glyphOrientationVertical =
    Origami.VirtualDom.attribute "glyph-orientation-vertical"


{-| -}
imageRendering : String -> Attribute msg
imageRendering =
    Origami.VirtualDom.attribute "image-rendering"


{-| -}
kerning : String -> Attribute msg
kerning =
    Origami.VirtualDom.attribute "kerning"


{-| -}
letterSpacing : String -> Attribute msg
letterSpacing =
    Origami.VirtualDom.attribute "letter-spacing"


{-| -}
lightingColor : String -> Attribute msg
lightingColor =
    Origami.VirtualDom.attribute "lighting-color"


{-| -}
markerEnd : String -> Attribute msg
markerEnd =
    Origami.VirtualDom.attribute "marker-end"


{-| -}
markerMid : String -> Attribute msg
markerMid =
    Origami.VirtualDom.attribute "marker-mid"


{-| -}
markerStart : String -> Attribute msg
markerStart =
    Origami.VirtualDom.attribute "marker-start"


{-| -}
mask : String -> Attribute msg
mask =
    Origami.VirtualDom.attribute "mask"


{-| -}
opacity : String -> Attribute msg
opacity =
    Origami.VirtualDom.attribute "opacity"


{-| -}
overflow : String -> Attribute msg
overflow =
    Origami.VirtualDom.attribute "overflow"


{-| -}
pointerEvents : String -> Attribute msg
pointerEvents =
    Origami.VirtualDom.attribute "pointer-events"


{-| -}
shapeRendering : String -> Attribute msg
shapeRendering =
    Origami.VirtualDom.attribute "shape-rendering"


{-| -}
stopColor : String -> Attribute msg
stopColor =
    Origami.VirtualDom.attribute "stop-color"


{-| -}
stopOpacity : String -> Attribute msg
stopOpacity =
    Origami.VirtualDom.attribute "stop-opacity"


{-| -}
strokeDasharray : String -> Attribute msg
strokeDasharray =
    Origami.VirtualDom.attribute "stroke-dasharray"


{-| -}
strokeDashoffset : String -> Attribute msg
strokeDashoffset =
    Origami.VirtualDom.attribute "stroke-dashoffset"


{-| -}
strokeLinecap : String -> Attribute msg
strokeLinecap =
    Origami.VirtualDom.attribute "stroke-linecap"


{-| -}
strokeLinejoin : String -> Attribute msg
strokeLinejoin =
    Origami.VirtualDom.attribute "stroke-linejoin"


{-| -}
strokeMiterlimit : String -> Attribute msg
strokeMiterlimit =
    Origami.VirtualDom.attribute "stroke-miterlimit"


{-| -}
strokeOpacity : String -> Attribute msg
strokeOpacity =
    Origami.VirtualDom.attribute "stroke-opacity"


{-| -}
strokeWidth : String -> Attribute msg
strokeWidth =
    Origami.VirtualDom.attribute "stroke-width"


{-| -}
stroke : String -> Attribute msg
stroke =
    Origami.VirtualDom.attribute "stroke"


{-| -}
textAnchor : String -> Attribute msg
textAnchor =
    Origami.VirtualDom.attribute "text-anchor"


{-| -}
textDecoration : String -> Attribute msg
textDecoration =
    Origami.VirtualDom.attribute "text-decoration"


{-| -}
textRendering : String -> Attribute msg
textRendering =
    Origami.VirtualDom.attribute "text-rendering"


{-| -}
unicodeBidi : String -> Attribute msg
unicodeBidi =
    Origami.VirtualDom.attribute "unicode-bidi"


{-| -}
visibility : String -> Attribute msg
visibility =
    Origami.VirtualDom.attribute "visibility"


{-| -}
wordSpacing : String -> Attribute msg
wordSpacing =
    Origami.VirtualDom.attribute "word-spacing"


{-| -}
writingMode : String -> Attribute msg
writingMode =
    Origami.VirtualDom.attribute "writing-mode"
