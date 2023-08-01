local Types = require(script.Parent.Parent.Types)

return function(Iris: Types.Iris, widgets: Types.WidgetUtility)
    local numberChanged = {
        ["Init"] = function(thisWidget: Types.Widget) end,
        ["Get"] = function(thisWidget: Types.Widget)
            return thisWidget.lastNumberChangedTick == Iris._cycleTick
        end,
    }

    --[[
        Widgets:
            Input:
                - Text
                - Number
                - Vector2
                - Vector3
                - UDim
                - UDim2
            Drag:
                - Number
                - Vector2
                - Vector3
                - UDim
                - UDim2
                - Color3
                - Color4
            Slider:
                - Number
                - Vector2
                - Vector3
                - UDim
                - UDim2
                - Angle
                - Enum

        Types:
            InputText:
                - Label: string
                - Hint: string?
            
            InputNum:
                - Label: string
                - Increment: number? = 1
                - Min: number?
                - Max: number?
                - Format: string?
            InputVector2:
                - Label: string
                - Increment: Vector2? = Vector2.new(0.1, 0.1)
                - Min: Vector2?
                - Max: Vector2?
            InputVector3:
                - Label: string
                - Increment: Vector3? = Vector3.new(0.1, 0.1)
                - Min: Vector3?
                - Max: Vector3?
            InputUDim:
                - Label: string
                - Increment: UDim? = UDim.new(0.1, 1)
                - Min: UDim?
                - Max: UDim?
            InputUDim2:
                - Label: string
                - Increment: UDim2? = UDim2.new(0.1, 1, 0.1, 1)
                - Min: UDim2?
                - Max: UDim2?

            DragNum:
                - Label: string
                - Increment: number? = 1
                - Min: number?
                - Max: number?
                - Format: string?
            DragVector2
                - Label: string
                - Increment: Vector2? = Vector2.new(0.1, 0.1)
                - Min: Vector2?
                - Max: Vector2?
                - Format: string?
            DragVector3:
                - Label: string
                - Increment: Vector3? = Vector3.new(0.1, 0.1, 0.1)
                - Min: Vector3?
                - Max: Vector3?
                - Format: string?
            DragUDim:
                - Label: string
                - Increment: UDim? = UDim.new(0.1, 1)
                - Min: UDim?
                - Max: UDim?
                - Format: string?
            DragUDim2:
                - Label: string
                - Increment: UDim2? = UDim2.new(0.1, 1, 0.1, 1)
                - Min: UDim2?
                - Max: UDim2?
                - Format: string?
            
            InputColor3:
                - Label: string
                - UseFloat: boolean? = false
                - UseHSV: boolean? = false
                - Min: number = 0
                - Max: number = if UseFloats then 1 else 255
                - Format: string = nil
            InputColor4:
                - Label: string
                - UseFloat: boolean? = false
                - UseHSV: boolean? = false
                - Min: number = 0
                - Max: number = if UseFloats then 1 else 255
                - Format: string = nil
            
            SliderNum:
                - Label: string
                - Increment: number? = 1
                - Min: number
                - Max: number
                - Format: string?
            SliderVector2:
                - Label: string
                - Increment: Vector2? = 1
                - Min: Vector2
                - Max: Vector2
                - Format: string?
            SliderVector3:
                - Label: string
                - Increment: Vector3? = 1
                - Min: Vector3
                - Max: Vector3
                - Format: string?
            SliderUDim:
                - Label: string
                - Increment: UDim? = 1
                - Min: UDim
                - Max: UDim
                - Format: string?
            SliderUDim2:
                - Label: string
                - Increment: UDim2? = 1
                - Min: UDim2
                - Max: UDim2
                - Format: string?
            SliderEnum:
                - Label: string
                - Increment: mumber = 1
                - Min: number = 0
                - Max: number = #values
                - Format: any = enum[value]

		- DragScalar
        - SliderScalar
        - InputScalar
    ]]

    local function getValueByIndex(value: Types.InputDataType, index: number): number
        if typeof(value) == "number" then
            return value
        elseif typeof(value) == "Vector2" then
            if index == 1 then
                return value.X
            elseif index == 2 then
                return value.Y
            end
        elseif typeof(value) == "Vector3" then
            if index == 1 then
                return value.X
            elseif index == 2 then
                return value.Y
            elseif index == 3 then
                return value.Z
            end
        elseif typeof(value) == "UDim" then
            if index == 1 then
                return value.Scale
            elseif index == 2 then
                return value.Offset
            end
        elseif typeof(value) == "UDim2" then
            if index == 1 then
                return value.X.Scale
            elseif index == 2 then
                return value.X.Offset
            elseif index == 3 then
                return value.Y.Scale
            elseif index == 4 then
                return value.Y.Offset
            end
        elseif typeof(value) == "Color3" then
            if index == 1 then
                return value.R
            elseif index == 2 then
                return value.G
            elseif index == 3 then
                return value.B
            end
        end

        error(`Incorrect datatype or value: {value} {typeof(value)} {index}`)
    end

    local function updateValueByIndex(value: Types.InputDataType, index: number, newValue: number): Types.InputDataType
        if typeof(value) == "number" then
            return newValue
        elseif typeof(value) == "Vector2" then
            if index == 1 then
                return Vector2.new(newValue, value.Y)
            elseif index == 2 then
                return Vector2.new(value.X, newValue)
            end
        elseif typeof(value) == "Vector3" then
            if index == 1 then
                return Vector3.new(newValue, value.Y, value.Z)
            elseif index == 2 then
                return Vector3.new(value.X, newValue, value.Z)
            elseif index == 3 then
                return Vector3.new(value.X, value.Y, newValue)
            end
        elseif typeof(value) == "UDim" then
            if index == 1 then
                return UDim.new(newValue, value.Offset)
            elseif index == 2 then
                return UDim.new(value.Scale, newValue)
            end
        elseif typeof(value) == "UDim2" then
            if index == 1 then
                return UDim2.new(UDim.new(newValue, value.X.Offset), value.Y)
            elseif index == 2 then
                return UDim2.new(UDim.new(value.X.Scale, newValue), value.Y)
            elseif index == 3 then
                return UDim2.new(value.X, UDim.new(newValue, value.Y.Offset))
            elseif index == 4 then
                return UDim2.new(value.X, UDim.new(value.Y.Scale, newValue))
            end
        elseif typeof(value) == "Color3" then
            if index == 1 then
                return Color3.new(newValue, value.G, value.B)
            elseif index == 2 then
                return Color3.new(value.R, newValue, value.B)
            elseif index == 3 then
                return Color3.new(value.R, value.G, newValue)
            end
        end

        error("")
    end

    local function generateInputScalar(dataType: Types.InputDataTypes, components: number, defaultValue: any)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                ["Text"] = 1,
                ["Increment"] = 2,
                ["Min"] = 3,
                ["Max"] = 4,
                ["Format"] = 5,
                ["NoButtons"] = 6,
            },
            Events = {
                ["numberChanged"] = numberChanged,
                ["hovered"] = widgets.EVENTS.hover(function(thisWidget: Types.Widget)
                    return thisWidget.Instance
                end),
            },
            Generate = function(thisWidget: Types.Widget)
                local Input: Frame = Instance.new("Frame")
                Input.Name = "Iris_Input" .. dataType
                Input.Size = UDim2.fromScale(1, 0)
                Input.BackgroundTransparency = 1
                Input.BorderSizePixel = 0
                Input.ZIndex = thisWidget.ZIndex
                Input.LayoutOrder = thisWidget.ZIndex
                Input.AutomaticSize = Enum.AutomaticSize.Y
                widgets.UIListLayout(Input, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))

                -- we add plus and minus buttons if there is only one box. This can be disabled through the argument.
                local rightPadding: number = 0
                local textHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
                if components == 1 then
                    rightPadding += 2 * Iris._config.ItemInnerSpacing.X + 2 * textHeight

                    local SubButton = widgets.abstractButton.Generate(thisWidget) :: TextButton
                    SubButton.Name = "SubButton"
                    SubButton.ZIndex = thisWidget.ZIndex + 5
                    SubButton.LayoutOrder = thisWidget.ZIndex + 5
                    SubButton.TextXAlignment = Enum.TextXAlignment.Center
                    SubButton.Text = "-"
                    SubButton.Size = UDim2.fromOffset(Iris._config.TextSize - 2 * (Iris._config.FramePadding.X - Iris._config.FramePadding.Y), Iris._config.TextSize)
                    SubButton.Parent = Input

                    SubButton.MouseButton1Click:Connect(function()
                        local isCtrlHeld = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                        local changeValue = (thisWidget.arguments.Increment or 1) * (isCtrlHeld and 100 or 1)
                        local newValue = thisWidget.state.number.value - changeValue
                        if thisWidget.arguments.Min ~= nil then
                            newValue = math.max(newValue, thisWidget.arguments.Min)
                        end
                        if thisWidget.arguments.Max ~= nil then
                            newValue = math.min(newValue, thisWidget.arguments.Max)
                        end
                        thisWidget.state.number:set(newValue)
                        thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
                    end)

                    local AddButton = widgets.abstractButton.Generate(thisWidget) :: TextButton
                    AddButton.Name = "AddButton"
                    AddButton.ZIndex = thisWidget.ZIndex + 6
                    AddButton.LayoutOrder = thisWidget.ZIndex + 6
                    AddButton.TextXAlignment = Enum.TextXAlignment.Center
                    AddButton.Text = "+"
                    AddButton.Size = UDim2.fromOffset(Iris._config.TextSize - 2 * (Iris._config.FramePadding.X - Iris._config.FramePadding.Y), Iris._config.TextSize)
                    AddButton.Parent = Input

                    AddButton.MouseButton1Click:Connect(function()
                        local isCtrlHeld = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                        local changeValue = (thisWidget.arguments.Increment or 1) * (isCtrlHeld and 100 or 1)
                        local newValue = thisWidget.state.number.value + changeValue
                        if thisWidget.arguments.Min ~= nil then
                            newValue = math.max(newValue, thisWidget.arguments.Min)
                        end
                        if thisWidget.arguments.Max ~= nil then
                            newValue = math.min(newValue, thisWidget.arguments.Max)
                        end
                        thisWidget.state.number:set(newValue)
                        thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
                    end)
                end

                local componentWidth: UDim2 = UDim2.new(Iris._config.ContentWidth.Scale / components, (Iris._config.ContentWidth.Offset - (Iris._config.ItemInnerSpacing.X * (components - 1))) / components - rightPadding, 0, 0)

                -- we handle each component individually since they don't need to interact with each other.
                for index = 1, components do
                    local InputField: TextBox = Instance.new("TextBox")
                    InputField.Name = "InputField" .. tostring(index)
                    InputField.ZIndex = thisWidget.ZIndex + index
                    InputField.LayoutOrder = thisWidget.ZIndex + index
                    InputField.Size = componentWidth
                    InputField.AutomaticSize = Enum.AutomaticSize.Y
                    InputField.BackgroundColor3 = Iris._config.FrameBgColor
                    InputField.BackgroundTransparency = Iris._config.FrameBgTransparency
                    InputField.ClearTextOnFocus = false
                    InputField.TextTruncate = Enum.TextTruncate.AtEnd
                    InputField.ClipsDescendants = true

                    widgets.applyFrameStyle(InputField)
                    widgets.applyTextStyle(InputField)
                    widgets.UISizeConstraint(InputField, Vector2.new(1, 0))

                    InputField.Parent = Input

                    InputField.FocusLost:Connect(function()
                        local newValue: number? = tonumber(InputField.Text:match("-?%d*%.?%d*"))
                        if newValue ~= nil then
                            if thisWidget.arguments.Min ~= nil then
                                newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, index))
                            end
                            if thisWidget.arguments.Max ~= nil then
                                newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, index))
                            end

                            if thisWidget.arguments.Increment then
                                newValue = math.floor(newValue / getValueByIndex(thisWidget.arguments.Increment, index)) * getValueByIndex(thisWidget.arguments.Increment, index)
                            end

                            thisWidget.state.number:set(updateValueByIndex(thisWidget.state.number.value, index, newValue))
                            thisWidget.lastNumberChangedTick = Iris._cycleTick + 1

                            if thisWidget.arguments.Format then
                                InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                            else
                                -- this prevents float values to UDim offsets
                                local value: number = getValueByIndex(thisWidget.state.number.value, index)
                                InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                            end
                        else
                            if thisWidget.arguments.Format then
                                InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                            else
                                local value: number = getValueByIndex(thisWidget.state.number.value, index)
                                InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                            end
                        end

                        thisWidget.state.editingText:set(0)
                    end)

                    InputField.Focused:Connect(function()
                        -- this highlights the entire field
                        InputField.CursorPosition = #InputField.Text + 1
                        InputField.SelectionStart = 1

                        thisWidget.state.editingText:set(index)
                    end)
                end

                local TextLabel: TextLabel = Instance.new("TextLabel")
                TextLabel.Name = "TextLabel"
                TextLabel.Size = UDim2.fromOffset(0, textHeight)
                TextLabel.BackgroundTransparency = 1
                TextLabel.BorderSizePixel = 0
                TextLabel.ZIndex = thisWidget.ZIndex + 7
                TextLabel.LayoutOrder = thisWidget.ZIndex + 7
                TextLabel.AutomaticSize = Enum.AutomaticSize.X

                widgets.applyTextStyle(TextLabel)

                TextLabel.Parent = Input

                return Input
            end,
            Update = function(thisWidget: Types.Widget)
                local Input = thisWidget.Instance :: GuiObject
                local TextLabel: TextLabel = Input.TextLabel

                if components == 1 then
                    Input.SubButton.Visible = not thisWidget.arguments.NoButtons
                    Input.AddButton.Visible = not thisWidget.arguments.NoButtons
                end

                TextLabel.Text = thisWidget.arguments.Text or "Input " .. dataType
            end,
            Discard = function(thisWidget: Types.Widget)
                thisWidget.Instance:Destroy()
                widgets.discardState(thisWidget)
            end,
            GenerateState = function(thisWidget: Types.Widget)
                if thisWidget.state.number == nil then
                    thisWidget.state.number = Iris._widgetState(thisWidget, "value", defaultValue)
                end
                if thisWidget.state.editingText == nil then
                    thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", 0)
                end
            end,
            UpdateState = function(thisWidget: Types.Widget)
                local Input = thisWidget.Instance :: GuiObject

                for index = 1, components do
                    local InputField: TextBox = Input:FindFirstChild("InputField" .. tostring(index))
                    if thisWidget.arguments.Format then
                        InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                    else
                        local value: number = getValueByIndex(thisWidget.state.number.value, index)
                        InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                    end
                end
            end,
        }
    end

    local ActiveIndex: number = 0

    local PreviouseMouseXPosition: number = 0
    local AnyActiveDrag: boolean = false
    local ActiveDrag: Types.Widget? = nil

    local function updateActiveDrag()
        local currentMouseX: number = widgets.UserInputService:GetMouseLocation().X
        local mouseXDelta: number = currentMouseX - PreviouseMouseXPosition
        PreviouseMouseXPosition = currentMouseX
        if AnyActiveDrag == false then
            return
        end
        if ActiveDrag == nil then
            return
        end

        local increment: number = 1
        if ActiveDrag.arguments.Increment then
            increment = getValueByIndex(ActiveDrag.arguments.Increment, ActiveIndex)
        end
        increment *= (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1
        increment *= (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1

        local value: number = getValueByIndex(ActiveDrag.state.number.value, ActiveIndex)
        local newValue: number = value + (mouseXDelta * increment)

        if ActiveDrag.arguments.Min ~= nil then
            newValue = math.max(newValue, getValueByIndex(ActiveDrag.arguments.Min, ActiveIndex))
        end
        if ActiveDrag.arguments.Max ~= nil then
            newValue = math.min(newValue, getValueByIndex(ActiveDrag.arguments.Max, ActiveIndex))
        end

        ActiveDrag.state.number:set(updateValueByIndex(ActiveDrag.state.number.value, ActiveIndex, newValue))
        ActiveDrag.lastNumberChangedTick = Iris._cycleTick + 1
    end

    local function DragMouseDown(thisWidget: Types.Widget, index: number, x: number, y: number)
        local currentTime: number = widgets.getTime()
        local isTimeValid: boolean = currentTime - thisWidget.lastClickedTime < Iris._config.MouseDoubleClickTime
        local isCtrlHeld: boolean = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        if (isTimeValid and (Vector2.new(x, y) - thisWidget.lastClickedPosition).Magnitude < Iris._config.MouseDoubleClickMaxDist) or isCtrlHeld then
            thisWidget.state.editingText:set(index)
        else
            thisWidget.lastClickedTime = currentTime
            thisWidget.lastClickedPosition = Vector2.new(x, y)

            AnyActiveDrag = true
            ActiveDrag = thisWidget
            ActiveIndex = index
            updateActiveDrag()
        end
    end

    widgets.UserInputService.InputChanged:Connect(updateActiveDrag)

    widgets.UserInputService.InputEnded:Connect(function(inputObject: InputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and AnyActiveDrag then
            AnyActiveDrag = false
            ActiveDrag = nil
            ActiveIndex = 0
        end
    end)

    local function generateDragScalar(dataType: Types.InputDataTypes, components: number, defaultValue: any)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                ["Text"] = 1,
                ["Increment"] = 2,
                ["Min"] = 3,
                ["Max"] = 4,
                ["Format"] = 5,
            },
            Events = {
                ["numberChanged"] = numberChanged,
                ["hovered"] = widgets.EVENTS.hover(function(thisWidget: Types.Widget)
                    return thisWidget.Instance
                end),
            },
            Generate = function(thisWidget: Types.Widget)
                thisWidget.lastClickedTime = -1
                thisWidget.lastClickedPosition = Vector2.zero

                local Drag: Frame = Instance.new("Frame")
                Drag.Name = "Iris_Drag" .. dataType
                Drag.Size = UDim2.fromScale(1, 0)
                Drag.BackgroundTransparency = 1
                Drag.BorderSizePixel = 0
                Drag.ZIndex = thisWidget.ZIndex
                Drag.LayoutOrder = thisWidget.ZIndex
                Drag.AutomaticSize = Enum.AutomaticSize.Y
                widgets.UIListLayout(Drag, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))

                local textHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
                local componentWidth: UDim2 = UDim2.new(Iris._config.ContentWidth.Scale / components, (Iris._config.ContentWidth.Offset - (Iris._config.ItemInnerSpacing.X * (components - 1))) / components, 0, 0)

                for index = 1, components do
                    local DragField: TextButton = Instance.new("TextButton")
                    DragField.Name = "DragField" .. tostring(index)
                    DragField.ZIndex = thisWidget.ZIndex + 1
                    DragField.LayoutOrder = thisWidget.ZIndex + 1
                    DragField.Size = componentWidth
                    DragField.AutomaticSize = Enum.AutomaticSize.Y
                    DragField.BackgroundColor3 = Iris._config.FrameBgColor
                    DragField.BackgroundTransparency = Iris._config.FrameBgTransparency
                    DragField.AutoButtonColor = false
                    DragField.Text = ""
                    DragField.ClipsDescendants = true

                    widgets.applyFrameStyle(DragField)
                    widgets.applyTextStyle(DragField)
                    widgets.UISizeConstraint(DragField, Vector2.new(1, 0))

                    DragField.TextXAlignment = Enum.TextXAlignment.Center

                    DragField.Parent = Drag

                    widgets.applyInteractionHighlights(DragField, DragField, {
                        ButtonColor = Iris._config.FrameBgColor,
                        ButtonTransparency = Iris._config.FrameBgTransparency,
                        ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = Iris._config.FrameBgActiveColor,
                        ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
                    })

                    local InputField: TextBox = Instance.new("TextBox")
                    InputField.Name = "InputField"
                    InputField.ZIndex = thisWidget.ZIndex + 2
                    InputField.LayoutOrder = thisWidget.ZIndex + 2
                    InputField.Size = UDim2.new(1, 0, 1, 0)
                    InputField.BackgroundTransparency = 1
                    InputField.ClearTextOnFocus = false
                    InputField.TextTruncate = Enum.TextTruncate.AtEnd
                    InputField.ClipsDescendants = true
                    InputField.Visible = false

                    widgets.applyFrameStyle(InputField, true)
                    widgets.applyTextStyle(InputField)

                    InputField.Parent = DragField

                    InputField.FocusLost:Connect(function()
                        local newValue: number? = tonumber(InputField.Text:match("-?%d*%.?%d*"))
                        if newValue ~= nil then
                            if thisWidget.arguments.Min ~= nil then
                                newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, index))
                            end
                            if thisWidget.arguments.Max ~= nil then
                                newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, index))
                            end

                            if thisWidget.arguments.Increment then
                                newValue = math.floor(newValue / getValueByIndex(thisWidget.arguments.Increment, index)) * getValueByIndex(thisWidget.arguments.Increment, index)
                            end

                            thisWidget.state.number:set(updateValueByIndex(thisWidget.state.number.value, index, newValue))
                            thisWidget.lastNumberChangedTick = Iris._cycleTick + 1

                            if thisWidget.arguments.Format then
                                InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                            else
                                -- this prevents float values to UDim offsets
                                local value: number = getValueByIndex(thisWidget.state.number.value, index)
                                InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                            end
                        else
                            if thisWidget.arguments.Format then
                                InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                            else
                                local value: number = getValueByIndex(thisWidget.state.number.value, index)
                                InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                            end
                        end

                        thisWidget.state.editingText:set(0)
                        InputField:ReleaseFocus(true)
                    end)

                    InputField.Focused:Connect(function()
                        -- this highlights the entire field
                        InputField.CursorPosition = #InputField.Text + 1
                        InputField.SelectionStart = 1

                        thisWidget.state.editingText:set(index)
                    end)

                    DragField.MouseButton1Down:Connect(function(x: number, y: number)
                        DragMouseDown(thisWidget, index, x, y)
                    end)
                end

                local TextLabel: TextLabel = Instance.new("TextLabel")
                TextLabel.Name = "TextLabel"
                TextLabel.Size = UDim2.fromOffset(0, textHeight)
                TextLabel.BackgroundTransparency = 1
                TextLabel.BorderSizePixel = 0
                TextLabel.ZIndex = thisWidget.ZIndex + 5
                TextLabel.LayoutOrder = thisWidget.ZIndex + 5
                TextLabel.AutomaticSize = Enum.AutomaticSize.X

                widgets.applyTextStyle(TextLabel)

                TextLabel.Parent = Drag

                return Drag
            end,
            Update = function(thisWidget: Types.Widget)
                local Input = thisWidget.Instance :: GuiObject
                local TextLabel: TextLabel = Input.TextLabel
                TextLabel.Text = thisWidget.arguments.Text or "Input Slider"
            end,
            Discard = function(thisWidget)
                thisWidget.Instance:Destroy()
                widgets.discardState(thisWidget)
            end,
            GenerateState = function(thisWidget)
                if thisWidget.state.number == nil then
                    thisWidget.state.number = Iris._widgetState(thisWidget, "value", defaultValue)
                end
                if thisWidget.state.editingText == nil then
                    thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
                end
            end,
            UpdateState = function(thisWidget)
                local Drag = thisWidget.Instance :: Frame

                for index = 1, components do
                    local DraField = Drag:FindFirstChild("DragField" .. tostring(index)) :: TextButton
                    local InputField: TextBox = DraField.InputField
                    if thisWidget.arguments.Format then
                        InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                    else
                        local value: number = getValueByIndex(thisWidget.state.number.value, index)
                        DraField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                        InputField.Text = tostring(value)
                    end

                    if thisWidget.state.editingText.value == index then
                        InputField.Visible = true
                        InputField:CaptureFocus()
                        DraField.TextTransparency = 1
                    else
                        InputField.Visible = false
                        DraField.TextTransparency = 0
                    end
                end
            end,
        }
    end

    local AnyActiveSlider: boolean = false
    local ActiveSlider: Types.Widget? = nil

    local function updateActiveSlider()
        local currentMouseX: number = widgets.UserInputService:GetMouseLocation().X
        local mouseXDelta: number = currentMouseX - PreviouseMouseXPosition
        PreviouseMouseXPosition = currentMouseX
        if AnyActiveDrag == false then
            return
        end
        if ActiveDrag == nil then
            return
        end

        local increment: number = 1
        if ActiveDrag.arguments.Increment then
            increment = getValueByIndex(ActiveDrag.arguments.Increment, ActiveIndex)
        end
        increment *= (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1
        increment *= (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1

        local value: number = getValueByIndex(ActiveDrag.state.number.value, ActiveIndex)
        local newValue: number = value + (mouseXDelta * increment)

        if ActiveDrag.arguments.Min ~= nil then
            newValue = math.max(newValue, getValueByIndex(ActiveDrag.arguments.Min, ActiveIndex))
        end
        if ActiveDrag.arguments.Max ~= nil then
            newValue = math.min(newValue, getValueByIndex(ActiveDrag.arguments.Max, ActiveIndex))
        end

        ActiveDrag.state.number:set(updateValueByIndex(ActiveDrag.state.number.value, ActiveIndex, newValue))
        ActiveDrag.lastNumberChangedTick = Iris._cycleTick + 1
    end

    local function SliderMouseDown(thisWidget: Types.Widget, index: number, x: number, y: number)
        local currentTime: number = widgets.getTime()
        local isTimeValid: boolean = currentTime - thisWidget.lastClickedTime < Iris._config.MouseDoubleClickTime
        local isCtrlHeld: boolean = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        if (isTimeValid and (Vector2.new(x, y) - thisWidget.lastClickedPosition).Magnitude < Iris._config.MouseDoubleClickMaxDist) or isCtrlHeld then
            thisWidget.state.editingText:set(index)
        else
            thisWidget.lastClickedTime = currentTime
            thisWidget.lastClickedPosition = Vector2.new(x, y)

            AnyActiveDrag = true
            ActiveDrag = thisWidget
            ActiveIndex = index
            updateActiveDrag()
        end
    end

    widgets.UserInputService.InputChanged:Connect(updateActiveDrag)

    widgets.UserInputService.InputEnded:Connect(function(inputObject: InputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and AnyActiveDrag then
            AnyActiveDrag = false
            ActiveDrag = nil
            ActiveIndex = 0
        end
    end)

    local function generateSliderScalar(dataType: Types.InputDataTypes, components: number, defaultValue: any)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                ["Text"] = 1,
                ["Increment"] = 2,
                ["Min"] = 3,
                ["Max"] = 4,
                ["Format"] = 5,
            },
            Events = {
                ["numberChanged"] = numberChanged,
                ["hovered"] = widgets.EVENTS.hover(function(thisWidget: Types.Widget)
                    return thisWidget.Instance
                end),
            },
            Generate = function(thisWidget: Types.Widget)
                thisWidget.lastClickedTime = -1
                thisWidget.lastClickedPosition = Vector2.zero

                local Drag: Frame = Instance.new("Frame")
                Drag.Name = "Iris_Drag" .. dataType
                Drag.Size = UDim2.fromScale(1, 0)
                Drag.BackgroundTransparency = 1
                Drag.BorderSizePixel = 0
                Drag.ZIndex = thisWidget.ZIndex
                Drag.LayoutOrder = thisWidget.ZIndex
                Drag.AutomaticSize = Enum.AutomaticSize.Y
                widgets.UIListLayout(Drag, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))

                local textHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
                local componentWidth: UDim2 = UDim2.new(Iris._config.ContentWidth.Scale / components, (Iris._config.ContentWidth.Offset - (Iris._config.ItemInnerSpacing.X * (components - 1))) / components, 0, 0)

                for index = 1, components do
                    local DragField: TextButton = Instance.new("TextButton")
                    DragField.Name = "DragField" .. tostring(index)
                    DragField.ZIndex = thisWidget.ZIndex + 1
                    DragField.LayoutOrder = thisWidget.ZIndex + 1
                    DragField.Size = componentWidth
                    DragField.AutomaticSize = Enum.AutomaticSize.Y
                    DragField.BackgroundColor3 = Iris._config.FrameBgColor
                    DragField.BackgroundTransparency = Iris._config.FrameBgTransparency
                    DragField.AutoButtonColor = false
                    DragField.Text = ""
                    DragField.ClipsDescendants = true

                    widgets.applyFrameStyle(DragField)
                    widgets.applyTextStyle(DragField)
                    widgets.UISizeConstraint(DragField, Vector2.new(1, 0))

                    DragField.TextXAlignment = Enum.TextXAlignment.Center

                    DragField.Parent = Drag

                    widgets.applyInteractionHighlights(DragField, DragField, {
                        ButtonColor = Iris._config.FrameBgColor,
                        ButtonTransparency = Iris._config.FrameBgTransparency,
                        ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = Iris._config.FrameBgActiveColor,
                        ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
                    })

                    local InputField: TextBox = Instance.new("TextBox")
                    InputField.Name = "InputField"
                    InputField.ZIndex = thisWidget.ZIndex + 2
                    InputField.LayoutOrder = thisWidget.ZIndex + 2
                    InputField.Size = UDim2.new(1, 0, 1, 0)
                    InputField.BackgroundTransparency = 1
                    InputField.ClearTextOnFocus = false
                    InputField.TextTruncate = Enum.TextTruncate.AtEnd
                    InputField.ClipsDescendants = true
                    InputField.Visible = false

                    widgets.applyFrameStyle(InputField, true)
                    widgets.applyTextStyle(InputField)

                    InputField.Parent = DragField

                    InputField.FocusLost:Connect(function()
                        local newValue: number? = tonumber(InputField.Text:match("-?%d*%.?%d*"))
                        if newValue ~= nil then
                            if thisWidget.arguments.Min ~= nil then
                                newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, index))
                            end
                            if thisWidget.arguments.Max ~= nil then
                                newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, index))
                            end

                            if thisWidget.arguments.Increment then
                                newValue = math.floor(newValue / getValueByIndex(thisWidget.arguments.Increment, index)) * getValueByIndex(thisWidget.arguments.Increment, index)
                            end

                            thisWidget.state.number:set(updateValueByIndex(thisWidget.state.number.value, index, newValue))
                            thisWidget.lastNumberChangedTick = Iris._cycleTick + 1

                            if thisWidget.arguments.Format then
                                InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                            else
                                -- this prevents float values to UDim offsets
                                local value: number = getValueByIndex(thisWidget.state.number.value, index)
                                InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                            end
                        else
                            if thisWidget.arguments.Format then
                                InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                            else
                                local value: number = getValueByIndex(thisWidget.state.number.value, index)
                                InputField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                            end
                        end

                        thisWidget.state.editingText:set(0)
                        InputField:ReleaseFocus(true)
                    end)

                    InputField.Focused:Connect(function()
                        -- this highlights the entire field
                        InputField.CursorPosition = #InputField.Text + 1
                        InputField.SelectionStart = 1

                        thisWidget.state.editingText:set(index)
                    end)

                    DragField.MouseButton1Down:Connect(function(x: number, y: number)
                        DragFieldMouseDown(thisWidget, index, x, y)
                    end)
                end

                local TextLabel: TextLabel = Instance.new("TextLabel")
                TextLabel.Name = "TextLabel"
                TextLabel.Size = UDim2.fromOffset(0, textHeight)
                TextLabel.BackgroundTransparency = 1
                TextLabel.BorderSizePixel = 0
                TextLabel.ZIndex = thisWidget.ZIndex + 5
                TextLabel.LayoutOrder = thisWidget.ZIndex + 5
                TextLabel.AutomaticSize = Enum.AutomaticSize.X

                widgets.applyTextStyle(TextLabel)

                TextLabel.Parent = Drag

                return Drag
            end,
            Update = function(thisWidget: Types.Widget)
                local Input = thisWidget.Instance :: GuiObject
                local TextLabel: TextLabel = Input.TextLabel
                TextLabel.Text = thisWidget.arguments.Text or "Input Slider"
            end,
            Discard = function(thisWidget)
                thisWidget.Instance:Destroy()
                widgets.discardState(thisWidget)
            end,
            GenerateState = function(thisWidget)
                if thisWidget.state.number == nil then
                    thisWidget.state.number = Iris._widgetState(thisWidget, "value", defaultValue)
                end
                if thisWidget.state.editingText == nil then
                    thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
                end
            end,
            UpdateState = function(thisWidget)
                local Drag = thisWidget.Instance :: Frame

                for index = 1, components do
                    local DraField = Drag:FindFirstChild("DragField" .. tostring(index)) :: TextButton
                    local InputField: TextBox = DraField.InputField
                    if thisWidget.arguments.Format then
                        InputField.Text = string.format(thisWidget.arguments.Format, getValueByIndex(thisWidget.state.number.value, index))
                    else
                        local value: number = getValueByIndex(thisWidget.state.number.value, index)
                        DraField.Text = string.format(if math.floor(value) == value then "%d" else "%.3f", value)
                        InputField.Text = tostring(value)
                    end

                    if thisWidget.state.editingText.value == index then
                        InputField.Visible = true
                        InputField:CaptureFocus()
                        DraField.TextTransparency = 1
                    else
                        InputField.Visible = false
                        DraField.TextTransparency = 0
                    end
                end
            end,
        }
    end

    Iris.WidgetConstructor("InputNum", generateInputScalar("Num", 1, 0))
    Iris.WidgetConstructor("InputVector2", generateInputScalar("Vector2", 2, Vector2.zero))
    Iris.WidgetConstructor("InputVector3", generateInputScalar("Vector3", 3, Vector3.zero))
    Iris.WidgetConstructor("InputUDim", generateInputScalar("UDim", 2, UDim.new()))
    Iris.WidgetConstructor("InputUDim2", generateInputScalar("UDim2", 4, UDim2.new()))

    Iris.WidgetConstructor("DragNum", generateDragScalar("Num", 1, 0))
    Iris.WidgetConstructor("DragVector2", generateDragScalar("Vector2", 2, Vector2.zero))
    Iris.WidgetConstructor("DragVector3", generateDragScalar("Vector3", 3, Vector3.zero))
    Iris.WidgetConstructor("DragUDim", generateDragScalar("UDim", 2, UDim.new()))
    Iris.WidgetConstructor("DragUDim2", generateDragScalar("UDim2", 4, UDim2.new()))
end