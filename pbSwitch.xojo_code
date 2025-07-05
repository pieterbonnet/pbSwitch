#tag Class
Protected Class pbSwitch
Inherits DesktopCanvas
	#tag Event
		Sub FocusLost()
		  Me.HaveFocus = False
		  me.Refresh
		  RaiseEvent FocusLost
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusReceived()
		  Me.HaveFocus = True
		  Me.Refresh
		  RaiseEvent FocusReceived
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  If key.Asc = 9 Then Return False
		  mPressed = True
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub KeyUp(key As String)
		  If key.Asc = 9 Then 
		    mPressed = False
		    Exit Sub
		  End
		  Me.Value = Not Me.Value
		  mPressed = False
		  Me.Refresh
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #Pragma Unused x
		  #Pragma Unused y
		  mPressed = True
		  me.Refresh
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  Me.mHover = True
		  Me.Refresh
		  RaiseEvent MouseEnter
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  Me.mHover = False
		  Me.Refresh
		  RaiseEvent MouseExit
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  #Pragma Unused x
		  #Pragma Unused y
		  
		  Me.mValue = Not Me.mValue
		  mPressed = False
		  Me.Refresh
		  RaiseEvent ValueChanged me.mValue, False
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  
		  g.SaveState // Saves the state to restore it when the AfterDraw Event is triggered
		  
		  // High quality
		  g.AntiAliased = True
		  g.AntiAliasMode = Graphics.AntiAliasModes.HighQuality
		  
		  Var Radius As Integer = g.Height
		  Var colBackColor As Color
		  Var colBorder As Color
		  Var colText As Color
		  Var colBall As Color
		  
		  // Determination of colors ////////////////////////////////////////
		  
		  // Set the color of the border
		  // If the control has the focus, then we systematically draw a border with the system color "HighLight"
		  // even if it is not enabled
		   
		  If Me.AllowFocusRing _
		  And Me.AllowFocus _
		  And Me.HaveFocus _
		  Then colBorder = Color.HighlightColor _
		  Else colBorder = Me.mBorderColor
		  
		  
		  // Sets the background Color (on Or off).
		  // If disabled, a System color, otherwise the property color.
		  // If the cursor Is over the control, it Is lightened.
		  
		  If Not Me.mEnabled Then
		    colBackColor = ChangeColorValue(Color.FillColor, -10)
		  ElseIf Me.value Then
		    colBackColor  =  mOnBackColor
		  Else
		    colBackColor = mOffBackColor
		  End
		  
		  If (Me.mPressed Or Me.mHover) And mEnabled Then colBackColor = ChangeColorValue(colBackColor, 25)
		  
		  
		  // Sets the color of the text, if enabled or automatic, or that of the property
		  
		  If Not Me.mEnabled Then
		    
		    colText = &cEFEFEF00 // Light Grey
		    
		  ElseIf Me.mValue Then // If On
		    
		    If mAutoOnTextColor Then
		      If BrightNess(mOnBackcolor) > 128 Then colText = Color.Black Else colText = Color.White
		    Else
		      colText = Me.mOnTextColor
		    End
		    
		  Else // if Off
		    
		    If mAutoOffTextColor Then
		      If BrightNess(mOffBackcolor) > 128 Then colText = Color.Black Else colText = Color.White
		    Else
		      colText = Me.mOffTextColor
		    End
		    
		  End
		  
		  // Set then color ot the ball
		  
		  If Not Me.mEnabled Then 
		    colBall = Color.DarkBevelColor
		  ElseIf Me.mValue Then
		    colBall = Me.mBallRightColor
		  Else
		    colBall = Me.mBallLeftColor
		  End
		  
		  
		  // End of determination of colors ////////////////////////////////////////
		  
		  // Draw the half discs of the sides
		  
		  g.DrawingColor = colBackColor
		  g.FillOval 0, 0, Radius, Radius
		  g.FillOval g.Width - Radius, 0, Radius, Radius
		  
		  // If necessary, drawing of the border of the discs
		  // If requested in the Property or if the control has focus
		  
		  If mBorderVisible Or (Me.AllowFocusRing And Me.AllowFocus And Me.HaveFocus) Then 
		    g.DrawingColor = colBorder
		    g.DrawOval 0, 0, Radius, Radius
		    g.DrawOval g.Width - Radius, 0, Radius, Radius
		  End
		  
		  // Drawing of the central rectangle
		  g.DrawingColor = colBackColor
		  g.FillRectangle (Radius/2),0, g.Width - Radius, Radius
		  
		  // If necessary, draw the border lines at the top and bottom
		  
		  If mBorderVisible Or (Me.AllowFocusRing And Me.AllowFocus And Me.HaveFocus) Then
		    g.DrawingColor = colBorder
		    g.DrawLine (Radius/2), 0, g.Width - (Radius/2) , 0
		    g.DrawLine (Radius/2), Radius - 1 , g.Width - (Radius/2), Radius - 1
		  End
		  
		  // Calculate the position of the ball
		  
		  Var xBall As Double
		  
		  If Me.value Then
		    
		    If mPressed Then
		      xBall = g.Width - Radius - mBallMargin
		    Else
		      xBall = g.Width - Radius + mBallMargin
		    End
		    
		  Else
		    
		    xBall = mBallMargin 
		    
		  End
		  
		  
		  
		  g.DrawingColor = colBall // Set the color of the ball
		  
		  //Drawing the ball.
		  //If animation is requested And the mouse button Is pressed, deformation towards the center Of the control.
		  
		  If Not mPressed Or Not mBallAnimation Then
		    
		    g.FillOval xBall, mBallMargin, Radius - (mBallMargin * 2), Radius - (mBallMargin * 2)
		    
		    If Me.mBallBorderVisible Then
		      g.DrawingColor = Me.mBallBorderColor
		      g.DrawOval xBall, mBallMargin, Radius - (mBallMargin * 2), Radius - (mBallMargin * 2)
		    End
		    
		  Else
		    
		    g.FillOval xBall, mBallMargin, Radius, Radius - (mBallMargin * 2)
		    
		    If Me.mBallBorderVisible Then
		      g.DrawingColor = Me.mBallBorderColor
		      g.DrawOval xBall, mBallMargin, Radius, Radius - (mBallMargin * 2)
		    End
		    
		  end
		  
		  // Drawing the text On Or Off
		  // Apply the settings
		  g.FontName = Me.mFontName
		  g.FontSize = Me.mFontSize
		  g.FontUnit = Me.mFontUnit
		  g.Bold = Me.mBold
		  g.Italic = Me.mItalic
		  g.Underline = Me.mUnderline
		  
		  
		  
		  
		  Var y As Double = (g.TextHeight("WWWW",2000) / 2) + 8 + Me.DeltaTextY
		  Var x As Double
		  Var w As Double
		  Var h As Double 
		  
		  g.DrawingColor = colText
		  
		  If Me.mValue And Me.OnText.Trim <> "" Then
		    
		    // Calculating coordinates 
		    w = g.TextWidth(Me.OnText)
		    h = g.TextHeight(Me.OnText, 2000)
		    y = (g.Height / 2) - h/2 + (g.FontAscent * 0.85) + Me.DeltaTextY
		    
		    w = g.TextWidth(Me.OnText)
		    g.DrawText Me.OnText.Trim, (radius/2) - 1 + mOnTextDeltaX, y, g.Width - Radius - mBallMargin - 4, True
		    
		  ElseIf Not Me.mValue And Me.OffText.Trim <> "" Then
		    
		    // Calculating coordinates 
		    w = g.TextWidth(Me.OffText)
		    h = g.TextHeight(Me.offText, 2000) 
		    y = (g.Height / 2) - h/2 + (g.FontAscent * 0.85) + Me.DeltaTextY
		    
		    x = g.Width - w - (radius / 2) - 1
		    g.DrawText Me.OffText.Trim, x + mOffTextDeltaX, y, g.Width - Radius - mBallMargin - 7, True
		    
		  End
		  
		  g.RestoreState // Restore the state
		  
		  RaiseEvent AfterDrawingSwitch(g, areas, Me.mPressed, Me.mHover)
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function BrightNess(c as color) As double
		  // Using https://alienryderflex.com/hsp.html
		  
		   Return  Sqrt( 0.299 * (c.Red^2) + 0.587 * (c.green^2) + 0.114 * (c.blue^2) )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ChangeColorValue(c as color, intensite as Integer = 15) As Color
		  Var value As Double
		  
		  If intensite < 0 Then
		    value = c.Value - (c.value * (Abs(intensite)/100))
		  Else
		    value = c.Value + (c.value * (Abs(intensite)/100))
		  End
		  
		  If value > 1  Then value = 1
		  
		  Return Color.HSV(c.Hue, c.Saturation, value)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LeftText() As string
		  Return me.mOnText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LeftText(assigns newValue as string)
		  If newValue <> Me.mOnText Then
		    Me.mOnText = newValue
		    Me.Refresh
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OnLeft() As Boolean
		  Return not mValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnLeft(assigns value as Boolean)
		  mValue = Not Value
		  RaiseEvent ValueChanged(value, True)
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OnRight() As Boolean
		  Return mValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnRight(assigns value as Boolean)
		  mValue = Value
		  RaiseEvent ValueChanged(value, True)
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RightText() As string
		  Return me.mOffText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RightText(assigns newValue as string)
		  If newValue <> Me.mOffText Then
		    Me.mOffText = newValue
		    Me.Refresh
		  End
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AfterDrawingSwitch(g as Graphics, areas() as Rect, Pressed as Boolean, Hover as Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FocusLost()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FocusReceived()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseEnter()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseExit()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ValueChanged(NewValue as boolean, ByCode as Boolean = True)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mAutoOffTextColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAutoOffTextColor = value
			End Set
		#tag EndSetter
		AutoOffTextColor As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mAutoOnTextColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAutoOnTextColor = value
			End Set
		#tag EndSetter
		AutoOnTextColor As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBallAnimation
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBallAnimation Then
			    mBallAnimation = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		BallAnimation As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBallBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBallBorderColor Then
			    mBallBorderColor = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		BallBorderColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBallBorderVisible
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBallBorderVisible Then
			    mBallBorderVisible = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		BallBorderVisible As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBallLeftColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBallLeftColor Then
			    mBallLeftColor = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		BallLeftColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBallMargin
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBallMargin Then
			    mBallMargin = value
			    Me.Refresh
			  End
			  
			  
			End Set
		#tag EndSetter
		BallMargin As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBallRightColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBallRightColor Then
			    mBallRightColor = value
			    Me.Refresh
			  End
			  
			  
			End Set
		#tag EndSetter
		BallRightColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBold
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mBold Then
			    mBold = value
			    me.Refresh
			  End If
			End Set
		#tag EndSetter
		Bold As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBorderColor = value
			End Set
		#tag EndSetter
		BorderColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBorderVisible
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBorderVisible = value
			End Set
		#tag EndSetter
		BorderVisible As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		DeltaTextY As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return desktopCanvas(Self).Enabled
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  me.Refresh
			  DesktopCanvas(Self).Enabled = value
			  Me.mEnabled = value
			End Set
		#tag EndSetter
		Enabled As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontName
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mFontName Then
			    mFontName = value
			    me.Refresh
			  End
			End Set
		#tag EndSetter
		FontName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mFontSize Then
			    mFontSize = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		FontSize As SIngle
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontUnit
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mFontUnit Then
			    mFontUnit = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		FontUnit As FontUnits
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private HaveFocus As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mItalic
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mItalic Then
			    mItalic = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		Italic As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAutoOffTextColor As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAutoOnTextColor As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBallAnimation As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBallBorderColor As Color = &cC0C0C000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBallBorderVisible As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBallLeftColor As Color = &cFFFFFF00
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBallMargin As Integer = 3
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBallRightColor As Color = &cFFFFFF00
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBorderColor As Color = &cA0A0A000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBorderVisible As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEnabled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontSize As SIngle
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontUnit As FontUnits = FontUnits.Point
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHover As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mItalic As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			'&cBB000000
		#tag EndNote
		Private mOffBackcolor As Color = &cBB000000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOffText As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOffTextColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOffTextDeltaX As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			'
		#tag EndNote
		Private mOnBackcolor As Color = &c00B02D00
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOnText As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOnTextColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOnTextDeltaX As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPressed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnderline As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValue As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOffBackcolor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mOffBackcolor Then
			    mOffBackcolor = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		OffBackcolor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOffTextDeltaX
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mOffTextDeltaX Then
			    mOffTextDeltaX = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		OffDeltaX As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOffText
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mOffText = value
			  me.Refresh
			End Set
		#tag EndSetter
		OffText As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOffTextColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mOffTextColor Then
			    mOffTextColor = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		OffTextColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOnBackcolor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mOnBackcolor Then
			    mOnBackcolor = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		OnBackcolor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return not mValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> Not mvalue Then
			    mValue = Not Value
			    RaiseEvent ValueChanged(mValue, True)
			    Me.Refresh
			  End
			End Set
		#tag EndSetter
		OnLeft As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <>  mValue Then
			    mValue = Value
			    RaiseEvent ValueChanged(mValue, True)
			    Me.Refresh
			  End
			End Set
		#tag EndSetter
		OnRight As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOnText
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mOnText = value
			  me.Refresh
			  
			End Set
		#tag EndSetter
		OnText As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOnTextColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mOnTextColor = value
			End Set
		#tag EndSetter
		OnTextColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOnTextDeltaX
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mOnTextDeltaX <> value Then
			    mOnTextDeltaX = value
			    Me.Refresh
			  End
			End Set
		#tag EndSetter
		OnTextDeltaX As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Tag As Variant
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mUnderline
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mUnderline Then
			    mUnderline = value
			    Me.Refresh
			  end
			End Set
		#tag EndSetter
		Underline As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> mValue Then
			    mValue = value
			    Me.Refresh
			    RaiseEvent ValueChanged(mValue, True)
			  End
			End Set
		#tag EndSetter
		Value As Boolean
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="70"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="24"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderVisible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=true
			Group="Appearance"
			InitialValue="&cB9B9B900"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DeltaTextY"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnLeft"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnRight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontUnit"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="FontUnits"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Pixel"
				"2 - Point"
				"3 - Inches"
				"4 - Millimeter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontSize"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="SIngle"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BallMargin"
			Visible=true
			Group="Appearance BALL"
			InitialValue="3"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BallAnimation"
			Visible=true
			Group="Appearance BALL"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BallBorderVisible"
			Visible=true
			Group="Appearance BALL"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BallBorderColor"
			Visible=true
			Group="Appearance BALL"
			InitialValue="&cB9B9B900"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BallLeftColor"
			Visible=true
			Group="Appearance BALL"
			InitialValue="&cF3F3F300"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BallRightColor"
			Visible=true
			Group="Appearance BALL"
			InitialValue="&cF3F3F300"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnBackcolor"
			Visible=true
			Group="Appearance ON"
			InitialValue="&c00A82B00"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnText"
			Visible=true
			Group="Appearance ON"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnTextDeltaX"
			Visible=true
			Group="Appearance ON"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoOnTextColor"
			Visible=true
			Group="Appearance ON"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnTextColor"
			Visible=true
			Group="Appearance ON"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffBackcolor"
			Visible=true
			Group="Appearance OFF"
			InitialValue="&cB0000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffText"
			Visible=true
			Group="Appearance OFF"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffDeltaX"
			Visible=true
			Group="Appearance OFF"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoOffTextColor"
			Visible=true
			Group="Appearance OFF"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffTextColor"
			Visible=true
			Group="Appearance OFF"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
