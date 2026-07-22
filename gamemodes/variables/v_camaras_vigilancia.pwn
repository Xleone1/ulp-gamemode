enum CamerasEnum
{
    Interior,
    World,
	Page,
	Float:PosXLook,
	Float:PosYLook,
	Float:PosZLook,
	Float:PosXAt,
	Float:PosYAt,
	Float:PosZAt
}
new Cameras[MAX_CAMERAS_COUNT][CamerasEnum];
new MAX_CAMERAS;

new Menu:CamerasM[2];