/*
WARNING
This function was added in SA-MP 0.3x and will not work in earlier versions!

Description
Set the model for a textdraw model preview. Click here to see this function's effect.

Name	Description
text	The textdraw id that will display the 3D preview.
modelindex	The GTA SA or SA:MP model ID to display.
Returns
This function does not return any specific values.

Examples
*/
new Text:textdraw;

public OnGameModeInit()
{
    textdraw = TextDrawCreate(320.0, 240.0, "_");
    TextDrawFont(textdraw, TEXT_DRAW_FONT_MODEL_PREVIEW);
    TextDrawUseBox(textdraw, 1);
    TextDrawBoxColor(textdraw, 0x000000FF);
    TextDrawTextSize(textdraw, 40.0, 40.0);
    TextDrawSetPreviewModel(textdraw, 411); //Display model 411 (Infernus)
        //TextDrawSetPreviewModel(textdraw, 1); //Display model 1 (CJ Skin)
        //TextDrawSetPreviewModel(textdraw, 18646); //Display model 18646 (Police light object)

    //You still have to use TextDrawShowForAll/TextDrawShowForPlayer to make the textdraw visible.
    return 1;
}

/*
Notes
TIP
Use TextDrawBackgroundColor to set the background color behind the model.

WARNING
The textdraw MUST use the font type TEXT_DRAW_FONT_MODEL_PREVIEW in order for this function to have effect.

Related Functions
TextDrawSetPreviewRot: Set rotation of a 3D textdraw preview.
TextDrawSetPreviewVehCol: Set the colours of a vehicle in a 3D textdraw preview.
TextDrawFont: Set the font of a textdraw.
PlayerTextDrawSetPreviewModel: Set model ID of a 3D player textdraw preview.
OnPlayerClickTextDraw: Called when a player clicks on a textdraw.
*/
