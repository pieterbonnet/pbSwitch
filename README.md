# pbSwitch

**Inherits from:** [DesktopCanvas](https://documentation.xojo.com/api/user_interface/desktop/desktopcanvas.html)

A **toggle switch** control drawn entirely in code, pill-shaped, with a moving ball, an optional text for each state and optional light effects (soft shadow, ball shading, recessed track).

---

## Description

`pbSwitch` is a subclass of `DesktopCanvas` that displays a two-state switch, in the style of modern mobile interfaces.

- The control's **height** defines the diameter of the ball and of the rounded ends; its **width** defines the length of the switch.
- The state is exposed through the [`Value`](#value) property (`True` = ball on the right, "On"; `False` = ball on the left, "Off").
- Each state has its own background color, text color and label.
- The control reacts to the mouse (hover, press, release) and to the keyboard (Space, Return and Enter keys).
- It handles keyboard focus and can draw a focus ring.
- Three optional effects give it some depth: a soft [ball shadow](#ballshadowintensity), a light [shading of the ball](#ballshadingintensity) and a [recessed track](#trackinsetintensity). They all use the same light direction (upper left).
- The [`AfterDrawingSwitch`](#afterdrawingswitch) event lets you draw on top of the standard rendering.

> [!NOTE]
> When `Value = True`, the ball is on the **right** and `OnText` is displayed (on the left side in `Ends` mode). When `Value = False`, the ball is on the **left** and `OffText` is displayed (on the right side in `Ends` mode).

> [!NOTE]
> **How this class was made.** The 3D effects of the control (the soft ball shadow, the shading of the ball and the recessed track) were created with [Claude](https://claude.ai), an AI assistant made by Anthropic, using a "vibe coding" approach: the effects were described in natural language, then generated and refined through conversation with the AI and tested visually in Xojo. This documentation was also written with Claude, as the author is not an English speaker. If you notice a mistake or an unclear sentence in the English text, feel free to report it.

---

## Table of contents

- [Properties](#properties)
- [Events](#events)
- [Enumerations](#enumerations)
- [Notes](#notes)
- [Sample code](#sample-code)
- [Compatibility](#compatibility)

---

## Properties

The properties are grouped by category:

| Category | Properties |
|---|---|
| [State](#state-properties) | [Value](#value), [OnRight](#onright), [OnLeft](#onleft), [Enabled](#enabled), [Tag](#tag) |
| [Text appearance](#text-appearance) | [OnText](#ontext), [OffText](#offtext), [TextAlignment](#textalignment), [OnTextDeltaX](#ontextdeltax), [OffTextDeltaX](#offtextdeltax), [DeltaTextY](#deltatexty), [Font properties](#font-properties), [AutoOnTextColor](#autoontextcolor), [AutoOffTextColor](#autoofftextcolor), [OnTextColor](#ontextcolor), [OffTextColor](#offtextcolor) |
| [Background appearance](#background-appearance) | [OnBackColor](#onbackcolor), [OffBackColor](#offbackcolor), [BorderVisible](#bordervisible), [BorderColor](#bordercolor) |
| [Ball appearance](#ball-appearance) | [BallLeftColor](#ballleftcolor), [BallRightColor](#ballrightcolor), [BallMargin](#ballmargin), [BallAnimation](#ballanimation), [BallBorderVisible](#ballbordervisible), [BallBorderColor](#ballbordercolor) |
| [3D effects](#3d-effects) | [TrackInsetIntensity](#trackinsetintensity), [TrackInsetDepth](#trackinsetdepth), [BallShadingIntensity](#ballshadingintensity), [BallShadingStyle](#ballshadingstyle), [BallShadowIntensity](#ballshadowintensity) |

---

### State properties

| Name | Type | Default value |
|---|---|---|
| [Enabled](#enabled) | `Boolean` | |
| [OnLeft](#onleft) | `Boolean` | |
| [OnRight](#onright) | `Boolean` | |
| [Tag](#tag) | `Variant` | |
| [Value](#value) | `Boolean` | `False` |

#### Value

`Value As Boolean`

The state of the switch. `True`: ball on the right ("On"). `False`: ball on the left ("Off").

When the value is changed **from code** and actually differs from the current one, the control is refreshed and the [`ValueChanged`](#valuechanged) event is raised with `ByCode = True`. Assigning the value already in effect does nothing.

```xojo
MySwitch.Value = True
```

#### OnRight

`OnRight As Boolean`

Equivalent to `Value`: `True` if the ball is on the right. Assigning a new value behaves like assigning `Value`.

#### OnLeft

`OnLeft As Boolean`

The inverse of `Value`: `True` if the ball is on the left. Assigning a new value behaves like assigning `Value` with the opposite value.

#### Enabled

`Enabled As Boolean`

Enables or disables the control. When disabled:

- the background is derived from `Color.FillColor`, darkened by 10%;
- the text is light gray (`&cEFEFEF`);
- the ball is drawn with `Color.DarkBevelColor`;
- hover and press effects are ignored;
- the [ball shading](#ballshadingintensity) and the [recessed track](#trackinsetintensity) effects are not drawn (flat look).

#### Tag

`Tag As Variant`

A free-form value available to the developer (not used by the class).

---

### Text appearance

| Name | Type | Default value |
|---|---|---|
| [AutoOffTextColor](#autoofftextcolor) | `Boolean` | `True` |
| [AutoOnTextColor](#autoontextcolor) | `Boolean` | `True` |
| [Bold](#font-properties) | `Boolean` | `False` |
| [DeltaTextY](#deltatexty) | `Double` | `0` |
| [FontName](#font-properties) | `String` | |
| [FontSize](#font-properties) | `Single` | |
| [FontUnit](#font-properties) | `FontUnits` | `FontUnits.Point` |
| [Italic](#font-properties) | `Boolean` | `False` |
| [OffText](#offtext) | `String` | `""` |
| [OffTextColor](#offtextcolor) | `Color` | `&c000000` (black) |
| [OffTextDeltaX](#offtextdeltax) | `Integer` | `0` |
| [OnText](#ontext) | `String` | `""` |
| [OnTextColor](#ontextcolor) | `Color` | `&c000000` (black) |
| [OnTextDeltaX](#ontextdeltax) | `Integer` | `0` |
| [TextAlignment](#textalignment) | [`TextAlignments`](#textalignments) | `TextAlignments.Ends` |
| [Underline](#font-properties) | `Boolean` | `False` |

#### OnText

`OnText As String`

The text displayed when `Value = True`. An empty or whitespace-only text is not drawn. The text is truncated to the available space.

#### OffText

`OffText As String`

The text displayed when `Value = False`. Same rules as `OnText`.

#### TextAlignment

`TextAlignment As TextAlignments`

How the texts are positioned. See the [`TextAlignments`](#textalignments) enumeration.

#### OnTextDeltaX

`OnTextDeltaX As Integer`

Horizontal offset (in pixels) applied to the `OnText` text.

#### OffTextDeltaX

`OffTextDeltaX As Integer`

Horizontal offset (in pixels) applied to the `OffText` text.

#### DeltaTextY

`DeltaTextY As Double`

Vertical offset (in pixels) applied to both texts, for fine adjustment of their vertical alignment.

#### Font properties

| Property | Type | Description |
|---|---|---|
| `FontName` | `String` | Name of the font used for the texts. |
| `FontSize` | `Single` | Font size. |
| `FontUnit` | `FontUnits` | Unit of the size (`Point` by default). |
| `Bold` | `Boolean` | Bold text. |
| `Italic` | `Boolean` | Italic text. |
| `Underline` | `Boolean` | Underlined text. |

Each change to one of these properties refreshes the control.

#### AutoOnTextColor

`AutoOnTextColor As Boolean`

If `True`, the color of the `OnText` text is chosen automatically (black or white) according to the brightness of `OnBackColor` (see [Notes](#automatic-text-color)). If `False`, `OnTextColor` is used.

#### AutoOffTextColor

`AutoOffTextColor As Boolean`

Same as above for `OffText`, using `OffBackColor` and `OffTextColor`.

#### OnTextColor

`OnTextColor As Color`

Color of the `OnText` text, used only if `AutoOnTextColor = False`.

#### OffTextColor

`OffTextColor As Color`

Color of the `OffText` text, used only if `AutoOffTextColor = False`.

---

### Background appearance

| Name | Type | Default value |
|---|---|---|
| [BorderColor](#bordercolor) | `Color` | `&cA0A0A0` |
| [BorderVisible](#bordervisible) | `Boolean` | `True` |
| [OffBackColor](#offbackcolor) | `Color` | `&cBB0000` (red) |
| [OnBackColor](#onbackcolor) | `Color` | `&c00B02D` (green) |

#### OnBackColor

`OnBackColor As Color`

Background color when `Value = True`. Default: `&c00B02D` (green).

#### OffBackColor

`OffBackColor As Color`

Background color when `Value = False`. Default: `&cBB0000` (red).

#### BorderVisible

`BorderVisible As Boolean`

Draws a border around the switch. The border is also drawn when the control has focus and the focus ring is allowed.

#### BorderColor

`BorderColor As Color`

Color of the border. If the control has focus and both `AllowFocus` and `AllowFocusRing` are `True`, the border is drawn with `Color.HighlightColor` instead.

---

### Ball appearance

| Name | Type | Default value |
|---|---|---|
| [BallAnimation](#ballanimation) | `Boolean` | `True` |
| [BallBorderColor](#ballbordercolor) | `Color` | `&cC0C0C0` |
| [BallBorderVisible](#ballbordervisible) | `Boolean` | `False` |
| [BallLeftColor](#ballleftcolor) | `Color` | `&cFFFFFF` (white) |
| [BallMargin](#ballmargin) | `Integer` | `3` |
| [BallRightColor](#ballrightcolor) | `Color` | `&cFFFFFF` (white) |

The light effects of the ball ([shading](#ballshadingintensity) and [shadow](#ballshadowintensity)) are described in the [3D effects](#3d-effects) section.

#### BallLeftColor

`BallLeftColor As Color`

Color of the ball when it is on the left (`Value = False`).

#### BallRightColor

`BallRightColor As Color`

Color of the ball when it is on the right (`Value = True`).

#### BallMargin

`BallMargin As Integer`

Margin, in pixels, between the ball and the edge of the switch. Negative values are ignored. Default: `3`.

#### BallAnimation

`BallAnimation As Boolean`

If `True`, the ball **stretches** toward the center of the control while the mouse button or a key is pressed (an iOS-like deformation effect). If `False`, the ball stays circular.

#### BallBorderVisible

`BallBorderVisible As Boolean`

Draws an outline around the ball.

#### BallBorderColor

`BallBorderColor As Color`

Color of the ball outline (if `BallBorderVisible = True`).

---

### 3D effects

| Name | Type | Default value |
|---|---|---|
| [BallShadingIntensity](#ballshadingintensity) | `Integer` | `0` |
| [BallShadingStyle](#ballshadingstyle) | [`BallShadingStyles`](#ballshadingstyles) | `BallShadingStyles.Convex` |
| [BallShadowIntensity](#ballshadowintensity) | `Integer` | `0` |
| [TrackInsetDepth](#trackinsetdepth) | `Integer` | `4` |
| [TrackInsetIntensity](#trackinsetintensity) | `Integer` | `0` |

Three optional effects give some depth to the control. They are all `0` by default: the control then keeps a flat look. They share the same light direction, coming from the **upper left**, so they combine consistently:

| Effect | Visual result |
|---|---|
| `TrackInsetIntensity` | The track looks recessed: dark along the upper-left edges, a light lip along the lower-right edges. |
| `BallShadingIntensity` | The ball is shaded: convex (lighter on the upper left, darker on the lower right) or concave, like a shallow dish (see `BallShadingStyle`). |
| `BallShadowIntensity` | The ball casts a soft shadow, toward the lower right, tinted by the background color. |

A subtle combination, for example `TrackInsetIntensity = 60`, `BallShadingIntensity = 40` and `BallShadowIntensity = 50`, gives a realistic relief.

The effects are rendered as translucent images that are cached, and only recomputed when the size, the position of the ball, the background color or the settings change. Hovering the control therefore remains inexpensive.

#### TrackInsetIntensity

`TrackInsetIntensity As Integer`

Intensity of the **recessed** effect of the track, from `0` (flat track, the default) to `100`. Values outside this range are clamped.

The body of the switch looks sunk into the surface, a few millimeters deep: an inner shadow runs along the upper-left edges, and a thin light lip along the lower-right edges, with a progressive fade toward the inside. The effect is drawn above the background and the border, and below the ball and the texts. It is not drawn when the control is disabled.

A value between `40` and `70` gives a natural result.

#### TrackInsetDepth

`TrackInsetDepth As Integer`

Depth of the recess, in pixels, from `1` to `20`. Values outside this range are clamped. Default: `4`. This property has no visible effect if `TrackInsetIntensity = 0`.

#### BallShadingIntensity

`BallShadingIntensity As Integer`

Intensity of the light shading of the ball, from `0` (flat ball, the default) to `100`. Values outside this range are clamped.

The shading style is chosen with [`BallShadingStyle`](#ballshadingstyle). In the `Convex` style (the default), instead of a uniform color, the ball is shaded as a slightly flattened sphere, with the same light direction as the rest of the control (upper left): the upper-left side is slightly lightened and the lower-right side is darkened, with a progressive transition. The shading follows the shape of the ball when it is stretched. It is not drawn when the control is disabled.

> [!NOTE]
> On a white ball (the default color), the lightening is not visible: only the darkening of the lower-right side shows. A colored or slightly gray ball makes the effect more readable. A value between `30` and `50` gives a subtle effect.

#### BallShadingStyle

`BallShadingStyle As BallShadingStyles`

Style of the ball shading, used when `BallShadingIntensity` is greater than `0`. See the [`BallShadingStyles`](#ballshadingstyles) enumeration. Default: `BallShadingStyles.Convex`.

```xojo
// A concave, dish-like ball
Me.BallMargin = 0
Me.BallBorderVisible = True
Me.BallBorderColor = &cACADAD00
Me.BallShadingStyle = pbSwitch.BallShadingStyles.Concave
Me.BallShadingIntensity = 75
```

#### BallShadowIntensity

`BallShadowIntensity As Integer`

Opacity of the shadow cast by the ball onto the track, from `0` (no shadow, the default) to `100`. Values outside this range are clamped.

The shadow is **soft and progressive**: it fades out smoothly around the ball instead of having a hard edge. It is cast toward the lower right (the light comes from the upper left) and its size follows the size of the ball. Its color is derived from the **background color** of the switch (darker and slightly more saturated, not black), so it blends with any background, including while the control is hovered. The shadow is clipped to the track and is not drawn while the ball is stretched by `BallAnimation` (the pressed ball looks pushed down).

A value between `40` and `70` gives a natural result.

---

## Events

### AfterDrawingSwitch

`AfterDrawingSwitch(g As Graphics, areas() As Rect, Pressed As Boolean, Hover As Boolean)`

Raised at the end of the `Paint` event, after the graphics state has been restored. It lets you draw additional elements on top of the switch (icons, badges, etc.).

| Parameter | Type | Description |
|---|---|---|
| `g` | `Graphics` | The graphics context of the control. |
| `areas()` | `Rect` | The areas to be redrawn. |
| `Pressed` | `Boolean` | `True` if the mouse button or a key is currently pressed. |
| `Hover` | `Boolean` | `True` if the pointer is over the control. |

### FocusLost

`FocusLost()`

The control has just lost keyboard focus. The control is redrawn before the event is raised.

### FocusReceived

`FocusReceived()`

The control has just received keyboard focus. The control is redrawn before the event is raised.

### MouseEnter

`MouseEnter()`

The pointer has entered the control. The hover state is stored and the control is redrawn (lightened background) before the event is raised.

### MouseExit

`MouseExit()`

The pointer has left the control. The hover state is reset and the control is redrawn before the event is raised.

### ValueChanged

`ValueChanged(NewValue As Boolean, ByCode As Boolean = True)`

The value of the switch has changed. The event is only raised if the value actually changes.

| Parameter | Type | Description |
|---|---|---|
| `NewValue` | `Boolean` | The new value (`True` = ball on the right). |
| `ByCode` | `Boolean` | `False` if the change was made by the user (mouse click, or key press while the control has focus); `True` if it was made from code. |

> [!NOTE]
> A change made by the user, with the mouse or with the keyboard while the control has focus, raises `ValueChanged(NewValue, False)`. A change made from code (assigning `Value`, `OnLeft` or `OnRight`) raises `ValueChanged(NewValue, True)`.

---

## Enumerations

### BallShadingStyles

Defines the look of the ball shading (see [`BallShadingIntensity`](#ballshadingintensity)).

| Constant | Description |
|---|---|
| `Convex` | The ball looks like a slightly flattened sphere, lit from the upper left: lighter on the upper left, darker on the lower right. This is the default value. |
| `Concave` | The ball looks like a shallow dish seen from above: darker at the top, progressively lighter toward the bottom, with the same gradient on the whole width. A fine light ring runs just inside the edge of the ball, strong at the top, weaker on the sides and almost absent at the bottom. For example, a white ball with `BallMargin = 0`, `BallBorderVisible = True`, `BallBorderColor = &cACADAD` and `BallShadingIntensity = 75` comes close to the style of the switches in the Xojo IDE. Higher values (up to `100`) make the ball darker. |

### TextAlignments

Defines how the `OnText` and `OffText` texts are positioned.

| Constant | Description |
|---|---|
| `Ends` | Texts are placed at the ends: `OnText` on the left side (opposite the ball) and `OffText` on the right side. This is the default value. |
| `Center` | Texts are centered in the free space of the switch, next to the ball. |

---

## Notes

### Dimensions

The diameter of the ball and of the rounded ends is equal to the control's **height** (`g.Height`). For a harmonious result, choose a width of at least about twice the height (for example 50 × 26 pixels), and more if you display text.

> [!NOTE]
> The ball shadow and the recessed track effects require a width greater than or equal to the height. Below that, they are not drawn.

### Interactions

| Action | Effect |
|---|---|
| Mouse button pressed | "Pressed" state (lightened background, deformed ball if `BallAnimation`). |
| Mouse button released over the control | The value is inverted, then `ValueChanged(NewValue, False)` is raised. |
| Mouse button released outside the control | The "pressed" state is cleared; the value does not change. |
| Space, Return or Enter key pressed | "Pressed" state. The key event is consumed by the control. |
| Space, Return or Enter key released | The value is inverted, then `ValueChanged(NewValue, False)` is raised. |
| Any other key (Tab included) | Ignored by the control: keyboard navigation between controls remains possible. |

### Automatic text color

When `AutoOnTextColor` or `AutoOffTextColor` is `True`, the text color is chosen according to the perceived brightness ([HSP model](https://alienryderflex.com/hsp.html)) of the corresponding background color:

```
Brightness = Sqrt(0.299 × R² + 0.587 × G² + 0.114 × B²)
```

If the brightness is greater than 128, the text is **black**, otherwise it is **white**.

### Hover and press

When the control is enabled and the pointer is over it (or it is pressed), the background color is lightened by 25% (increase of the value component in the HSV color space). The color transparency (alpha) is preserved.

### Focus

The focus ring (border in `Color.HighlightColor`) is only drawn if `AllowFocus` **and** `AllowFocusRing` are `True` and the control has focus. Both properties are inherited from `DesktopCanvas`.

---

## Sample code

### Basic switch

```xojo
// In a window's Opening event
MySwitch.OnText = "ON"
MySwitch.OffText = "OFF"
MySwitch.Value = False
```

### Reacting to a value change

In the control's `ValueChanged` event:

```xojo
Sub ValueChanged(NewValue As Boolean, ByCode As Boolean)
  If NewValue Then
    LabelState.Text = "Enabled"
  Else
    LabelState.Text = "Disabled"
  End If

  If Not ByCode Then
    // Change made by the user (mouse or keyboard)
    System.DebugLog("User action")
  End If
End Sub
```

### Full customization

```xojo
Sub Opening()
  Me.OnBackColor = &c2E7D3200
  Me.OffBackColor = &c9E9E9E00

  Me.BallLeftColor = Color.White
  Me.BallRightColor = Color.White
  Me.BallMargin = 3
  Me.BallAnimation = True

  Me.BorderVisible = False

  Me.OnText = "Yes"
  Me.OffText = "No"
  Me.TextAlignment = pbSwitch.TextAlignments.Ends
  Me.FontName = "System"
  Me.FontSize = 11
  Me.Bold = True
End Sub
```

### Relief effects

```xojo
Sub Opening()
  Me.BorderVisible = False

  // Recessed track, 4 pixels deep
  Me.TrackInsetIntensity = 60
  Me.TrackInsetDepth = 4

  // Convex ball with a soft shadow
  Me.BallShadingIntensity = 40
  Me.BallShadowIntensity = 50
End Sub
```

### Centered text and manual text colors

```xojo
Me.TextAlignment = pbSwitch.TextAlignments.Center
Me.AutoOnTextColor = False
Me.AutoOffTextColor = False
Me.OnTextColor = Color.White
Me.OffTextColor = &c33333300
```

### Drawing a symbol inside the ball

In the `AfterDrawingSwitch` event, this example draws a check mark (✓) inside the ball when the switch is on and a cross (×) inside the ball when it is off. Each symbol is drawn in the background color of its state (`OnBackColor` / `OffBackColor`). It assumes a control with `Height = 24`, `Width = 71` and `BallMargin = 3`.

```xojo
Sub AfterDrawingSwitch(g As Graphics, areas() As Rect, Pressed As Boolean, Hover As Boolean) Handles AfterDrawingSwitch
  #Pragma Unused areas

  // height = 24
  // width  = 71
  // BallMargin = 3

  If Me.Value Then
    g.DrawingColor = Me.OnBackColor
    g.Bold = True
    g.DrawText "✓", g.Width - 17, 16
  Else
    g.DrawingColor = Me.OffBackColor
    g.Bold = True
    g.FontSize = 20
    g.DrawText "×", 5, 18
  End
End Sub
```

> [!NOTE]
> The symbol coordinates are expressed in pixels and depend on the control's dimensions and on the ball position (right when on, left when off). Adjust them if you use a different size or a different `BallMargin`.

---

## Compatibility

| | |
|---|---|
| **Project types** | Desktop (API 2.0, `Desktop*` classes) |
| **Platforms** | macOS, Windows, Linux |
| **Parent class** | `DesktopCanvas` |

---

## See also

- [DesktopCanvas](https://documentation.xojo.com/api/user_interface/desktop/desktopcanvas.html)
- [Graphics](https://documentation.xojo.com/api/graphics/graphics.html)
- [Color](https://documentation.xojo.com/api/data_types/color.html)
