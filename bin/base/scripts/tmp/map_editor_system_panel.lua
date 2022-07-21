class "MapEditorSystemPanel" (Container)

function MapEditorSystemPanel:init()

    Observer:addListener("SwitchGrid", self, self.__onGridSwitched)
end

function MapEditorSystemPanel:__onBackBtnClick()
    Observer:call("ExitScreen")
end

function MapEditorSystemPanel:__onSaveBtnClick()
    Observer:call("SaveMapFile")
end

function MapEditorSystemPanel:__onLoadBtnClick()
    Observer:call("LoadMapFile")
end

function MapEditorSystemPanel:__onGridBtnClick()
    Observer:call("SwitchGrid")
end

function MapEditorSystemPanel:__onNewMapBtnClick()
    Observer:call("StartNewMap")
end
