    struct Config
    {
        std::string mapFolder;
    };

    class FileSystem
    {
    public:
        static std::vector<std::string> getFilesInFolder(const std::string & mapFilename)
        {
        }
    };
    struct HotKeys
    {
        std::string ScrollUp = "W";
        std::string ScrollLeft = "A";
        std::string ScrollRight = "D";
        std::string ScrollDown = "S";
        std::string Panel1 = "1";
        std::string Panel2 = "2";
        std::string Panel3 = "3";
        std::string Panel4 = "4";
        std::string Save = "F5";
        std::string Load = "F8";
        std::string Grid = "G";
        std::string Rotate = "R";
        std::string Flip = "F";
        std::string Edit = "E";
        std::string Next = "N";
        std::string Previous = "P";
        std::string Inventory = "I";
        std::string Cancel = "Escape";
    };

    enum RedRevoltEvents
    {
        RRE_ExitScreen,
        RRE_SaveMap,
        RRE_LoadMap,
        RRE_SwitchGrid,
        RRE_StartNewMap,
        RRE_ShowEditDialog,
        RRE_ShowNotification,
        RRE_ShowInventoryDialog,
        RRE_ShowSelectionPanel,
        RRE_ShowEntityPanel,
        RRE_EntityChanged,
        RRE_EntityRotated,
        RRE_EntityFlipped 
    };


    class MapEditorScreen;

   
    class Battlefield : public ScrollContainer
    {
    public:
        Battlefield(const std::string & id = String::kEmpty)
            : ScrollContainer(id)
        {
        }

        virtual ~Battlefield()
        {
        }
    };

    class MapEditorBattlefield : public Battlefield
    {
    public:
        MapEditorBattlefield(const std::string & id = String::kEmpty)
            : Battlefield(id)
        {
        }

        virtual ~MapEditorBattlefield()
        {
        }
    };

    class MapEditorEntitiesPanel : public Container
    {
    public:
        MapEditorEntitiesPanel(const std::string & id = String::kEmpty)
            : Container(id)
        {
        }

        virtual ~MapEditorEntitiesPanel()
        {
        }
    };

    class MapEditorSelectionPanel: public Container
    {
    public:
        MapEditorSelectionPanel(const std::string & id = String::kEmpty)
            : Container(id)
        {
        }

        virtual ~MapEditorSelectionPanel()
        {
        }
    };

    class MapEditorEditPanel: public Container 
    {
    public:
        MapEditorEditPanel(const std::string & id = String::kEmpty)
            : Container(id)
        {
        }

        virtual ~MapEditorEditPanel()
        {
        }
    }; 

    class MapEditorFiltersPanel: public Container 
    {
    public:
        MapEditorFiltersPanel(const std::string & id = String::kEmpty)
            : Container(id)
        {
            setRect(0, 0, 448, 64);
            setAlignment("CENTER|BOTTOM", 0, 0);

            addCallback("KeyUp_" + HotKeys::Panel1, this, &MapEditorScreen::changeFilter);
            addCallback("KeyUp_" + HotKeys::Panel2, this, &MapEditorScreen::changeFilter);
            addCallback("KeyUp_" + HotKeys::Panel3, this, &MapEditorScreen::changeFilter);
            addCallback("KeyUp_" + HotKeys::Panel4, this, &MapEditorScreen::changeFilter);

            addCallback("KeyUp_" + HotKeys::Next, this, &MapEditorScreen::selectNextEntity);
            addCallback("KeyUp_" + HotKeys::Previous, this, &MapEditorScreen::selectPrevEntity);

            Button * layerBtn = new Button("layerBtn");
            layerBtn->setRect(0, 0, 64, 64);
            layerBtn->setText("Layer");
            layerBtn->setColour("green");
            layerBtn->setFont("system_15_fnt");
            layerBtn->setTextAlign("CENTER|MIDDLE");
            layerBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            layerBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::switchLayer);
            attach(layerBtn);

            Button * prevBtn = new Button("prevBtn");
            prevBtn->setRect(64, 0, 64, 64);
            prevBtn->setText("Prev");
            prevBtn->setColour("green");
            prevBtn->setFont("system_15_fnt");
            prevBtn->setTextAlign("CENTER|MIDDLE");
            prevBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            prevBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::selectPrevEntity);
            attach(prevBtn);
             
            Button * nextBtn = new Button("nextBtn");
            nextBtn->setRect(128, 0, 64, 64);
            nextBtn->setText("Prev");
            nextBtn->setColour("green");
            nextBtn->setFont("system_15_fnt");
            nextBtn->setTextAlign("CENTER|MIDDLE");
            nextBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            nextBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::selectNextEntity);
            attach(nextBtn);

            Button * itemsBtn = new Button("itemsBtn");
            itemsBtn->setRect(192, 0, 64, 64);
            itemsBtn->setText("Items");
            itemsBtn->setColour("green");
            itemsBtn->setFont("system_15_fnt");
            itemsBtn->setTextAlign("CENTER|MIDDLE");
            itemsBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            itemsBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::onFilterBtnClick);
            attach(itemsBtn);

            Button * unitsBtn = new Button("unitsBtn");
            unitsBtn->setRect(256, 0, 64, 64);
            unitsBtn->setText("Units");
            unitsBtn->setColour("green");
            unitsBtn->setFont("system_15_fnt");
            unitsBtn->setTextAlign("CENTER|MIDDLE");
            unitsBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            unitsBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::onFilterBtnClick);
            attach(unitsBtn);

            Button * objectsBtn = new Button("objectsBtn");
            objectsBtn->setRect(320, 0, 64, 64);
            objectsBtn->setText("Objects");
            objectsBtn->setColour("green");
            objectsBtn->setFont("system_15_fnt");
            objectsBtn->setTextAlign("CENTER|MIDDLE");
            objectsBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            objectsBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::onFilterBtnClick);
            attach(objectsBtn);

            Button * terrainBtn = new Button("terrainBtn");
            terrainBtn->setRect(384, 0, 64, 64);
            terrainBtn->setText("Terrain");
            terrainBtn->setColour("green");
            terrainBtn->setFont("system_15_fnt");
            terrainBtn->setTextAlign("CENTER|MIDDLE");
            terrainBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            terrainBtn->addCallback("MouseUp_Left", this, &MapEditorFiltersPanel::onFilterBtnClick);
            attach(terrainBtn);
         }

        virtual ~MapEditorFiltersPanel()
        {
        }

    private:
        void switchLayer(Widget * sender)
        {
            // Observer:call("SwitchLayer")
        }

        void selectPrevEntity(Widget * sender)
        {
            //Observer:call("PrevEntity")
        }

        void selectNextEntity(Widget * sender)
        {
            //Observer:call("NextEntity")
        }

        void onFilterBtnClick(Widget * sender)
        {
            // const int index(1);
            // changeFilter(index);
        }

        void changeFilter(Widget * sender)
        {
            // Observer:call("ShowEntityPanel")
            // Observer:call("ChangeFilter", id)
        }
    }; 

    class MapEditorInfoPanel: public Container 
    {
    private:
        std::vector<Label *> m_slotLbls;
        std::vector<Label *> m_valueLbls;
        int m_slotsCount;
        Image * m_selectedImage;
        Label * m_selectedLbl;
    public:
        MapEditorInfoPanel(const std::string & id = String::kEmpty)
            : Container(id)
            , m_slotsount(6);
            , m_selectedImage(nullptr)
            , m_selectedLbl(nullptr)
        {
            m_selectedImg = new Image("selectedImg");
            m_selectedImg->setRect(0, 0, 32, 32);
            m_selectedImg->setAngle(0);
            m_selectedImg->setCenter(16, 16);
            attach(m_selectedImg);

            m_selectedLbl = new Label("selectedLbl");
            m_selectedLbl->setRect(40, 0, 200, 32);
            m_selectedLbl->setColour("white");
            m_selectedLbl->setFont("system_15_fnt");
            m_selectedLbl->setTextAlignment("LEFT|MIDDLE");
            attach(m_selectedLbl);

            for (int i = 0; i < m_slotsCount; ++i)
            {
                Label * lbl = new Label();
                lbl->setRect(240 + i * 80, 8, 30, 15);
                lbl->setColour("white");
                lbl->setFont("system_15_fnt");
                lbl->setTextAlignment("LEFT|MIDDLE");
                attach(lbl);
                m_slotLbls.push_back(lbl);

                Label * valueLbl = new Label();
                valueLbl->setRect(270 + i * 80, 8, 50, 15);
                valueLbl->setColour("white");
                valueLbl->setFont("system_15_fnt");
                valueLbl->setTextAlignment("LEFT|MIDDLE");
                attach(valueLbl);
                m_valueLbls.push_back(valueLbl);
            }

            addListener(RRE_EntityChanged this, $MapEditorInfoPanel::onEntityChanged);
            addListener(RRE_EntityRotated this, $MapEditorInfoPanel::onEntityRotated);
            addListener(RRE_EntityFlipped this, $MapEditorInfoPanel::onEntityFlipped);

            closeSlots();
        }

        virtual ~MapEditorInfoPanel()
        {
        }

    private:
        void onEntityChanged(Widget * sender)
        {
            closeSlots();
            Entity * entity(nullptr);
            update(entity);
        }

        void update(Entity * entity)
        {
            if (m_selectedImg)
            {
                m_selectedImg->instantView(nullptr != entity);
                if (entity)
                {
                    m_selectedImg->setSprite(entity->getSprite());
                    m_selectedImg->setAngle(entity->getAngle());
                    m_selectedImg->setFlip(entity->getFlipH(), entity.getFlipV());
                }
            }
            if (m_selectedLbl)
            {
                m_selectedLbl->instantView(nullptr != entity);
                if (entity)
                {
                    m_selectedLbl->setText(entity->getId());
                }
            }
            if (entity)
            {
                std::vector<EntityInfo> info = entity->getInfo();
                for (size_t i = 0; i < info.size(); ++i)
                {
                    const EntityInfo & data = info[i];
                    viewSlot(i, true);
                    updateSlot(i, data.slot, data.value);
                }
            }
        }

        void closeSlots()
        {
            for (int i = 0; i < m_slotsCount; ++i)
            {
                viewSlot(i, false);
            }
        }

        void onEntityRotated(Widget * sender)
        {
            int angle(0);
            if (m_selectedImg)
            {
                m_selectedImg->setAngle(angle);
            }
        }

        void onEntityFlipped(Widget * sender)
        {
            bool value_h(false);
            bool value_v(false);
            if (m_selectedImg)
            {
                m_selectedImg->setFlip(value_h, value_v);
            }
        }

        void viewSlot(const int index, const bool view)
        {
            if (index < m_slotLbls)
            {
                Label * lbl = m_slotLbls[index];
                if (lbl)
                {
                    lbl->instantView(view);
                }
            }

            if (index < m_valueLbls)
            {
                Label * lbl = m_valueLbls[index];
                if (lbl)
                {
                    lbl->instantView(view);
                }
            }
        }

        void updateSlot(const int index, const std::string & slot, const std::string & value)
        {
            if (index < m_slotLbls)
            {
                Label * lbl = m_slotLbls[index];
                if (lbl)
                {
                    lbl->setText(slot);
                }
            }

            if (index < m_valueLbls)
            {
                Label * lbl = m_valueLbls[index];
                if (lbl)
                {
                    lbl->setText(value);
                }
            }
        }
    }; 

    class MapEditorSaveLoadDialog: public Dialog 
    {
    private:
        bool m_isSave;
        std::vector<std::string> m_files;
        TextEdit * m_fileNameInput;
        ScrollContainer * m_folderCnt;
    public:
        MapEditorSaveLoadDialog(const std::string & id = String::kEmpty)
            : Dialog(id)
            , m_isSave(true)
            , m_fileNameInput(nullptr)
            , m_folderCnt(nullptr)
        {
            Transform openTransform;
            openTransform.add(0, 255, 500);
            attachTransform("WidgetOpening", openTransform);

            Transform closeTransform;
            closeTransform.add(255, 0, 500);
            attachTransform("WidgetClosing", closeTransform);

            setModal(true);
            setRect(0, 0, 500, 700);
            setAlignment("CENTER|MIDDLE", 0, 0);

            addCallback("WidgetOpening", this, &MapEditorSaveLoadDialog::onOpening);

            Image * img = new Image();
            img->setRect(0, 0, 500, 700);
            img->setSprite("dark_img_spr");
            attach(img);

            m_fileNameInput = new TextEdit("fileNameInput");
            m_fileNameInput->setRect(50, 10, 400, 30);
            m_fileNameInput->setText("new_map");
            m_fileNameInput->setColour("white");
            m_fileNameInput->setFont("system_24_fnt");
            attach(m_fileNameInput);

            Label * lbl = new Label();
            lbl->setRect(50, 50, 400, 30);
            lbl->setText("Maps in folder:");
            lbl->setColour("green");
            lbl->setFont("system_15_fnt");
            lbl->setTextAlignment("CENTER|MIDDLE");
            attach(lbl);

            m_folderCnt = new ScrollContainer("folderCnt");
            m_folderCnt->setRect(50, 80, 400, 520);
            attach(m_folderCnt);

            Button * btn = new Button("okBtn");
            btn->setRect(100, 636, 64, 64);
            btn->setText("OK");
            btn->setFont("system_15_fnt");
            btn->setColour("white");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MapEditorSaveLoadDialog::onOkBtnClick);
            attach(btn);

            Button * cancelBtn = new Button("cancelBtn");
            cancelBtn->setText("Cancel");
            cancelBtn->setFont("system_15_fnt");
            cancelBtn->setColour("white");
            cancelBtn->setTextAlignment("CENTER|MIDDLE");
            cancelBtn->setRect(336, 636, 64, 64);
            cancelBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            cancelBtn->addCallback("MouseUp_Left", this, &MapEditorSaveLoadDialog::onCancelBtnClick);
            attach(cancelBtn);
        }

        virtual ~MapEditorSaveLoadDialog()
        {
        }

        void onOpening(Widget * sender)
        {
            // Config.mapFolder
            if (m_folderCnt)
            {
                int i(0);
                m_folderCnt->detachAll();
                const Rect & rect = m_folderCnt->getRect();
                const x, y = rect.getX(), rect.getY();
                for (const std::string & file : m_files)
                {
                    const size_t pos = file.find(".map");
                    if (string::npos != pos)
                    {
                        const std::string text = file.erase(file.end() - pos, file.end());
                        Button * btn = new Button()
                        btn->setText(text);
                        btn->setFont("system_15_fnt");
                        btn->setTextAlignment("CENTER|MIDDLE");
                        btn->setColour("white");
                        btn->setRect(x, y + i * 30, 400, 30);
                        btn->addCallback("MouseUp_Left", this, &MapEditorSaveLoadDialog::onScrollerRowClick);
                        m_folderCnt->attach(btn);
                        ++i;
                    }
                }
            }
        }

        void switchToSave()
        {
            m_isSave = true;
        }

        void switchToLoad()
        {
            m_isSave = false;
        }

        void setFiles(const std::vector<std::string> & files)
        {
            m_files = files;
        }

        void onOkBtnClick(Widget * sender)
        {
            view(false);
            if (m_isSave)
            {
                // Observer:call("SaveMapFile", self:__getMapFile())
            }
            else
            {
                // Observer:call("LoadMapFile", nil, self:__getMapFile())
            }
        }

        void onCancelBtnClick(Widget * sender)
        {
            view(false);
        }

        const std::string & getMapFile()
        {
            if (m_fileNameInput)
            {
                m_fileNameInput->getText();
            }
            return QString::kEmptyString;
        }

        void onScrollerRowClick(Widget * sender)
        {
            if (m_fileNameInput)
            {
                Button * btn = dynamic_cast<Button *>(sender);
                if (btn)
                {
                    const std::string & text = btn->getText();
                    m_fileNameInput->setText(text);
                }
            }
         }
    }; 

    class NotificationDialog: public Dialog 
    {
    private:
        Label * m_messageLbl;
    public:
        NotificationDialog(const std::string & id = String::kEmpty)
            : Dialog(id)
            , m_messageLbl(nullptr)
        {
            const int width = Engine::getScreenWidth();
            const int height = Engine::getScreenHeight();

            Transform openTransform;
            openTransform.add(0, 255, 500);
            openTransform.add(100, 255, 1000);
            attachTransform("WidgetOpening", openTransform);

            Transform closeTransform;
            closeTransform.add(255, 0, 500);
            attachTransform("WidgetClosing", closeTransform);

            Image * img = new Image();
            img->setRect(0, 0, 300, 100);
            img->setSprite("dark_img_spr");
            img->setAlignment("CENTER|MIDDLE", 0, 0);
            attach(img);

            m_messageLbl = new Label("messageLbl");
            m_messageLbl->setRect(0, 0, 100, 30);
            m_messageLbl->setAlignment("CENTER|MIDDLE", 0, 0);
            m_messageLbl->setText("no text");
            m_messageLbl->setColour("white");
            m_messageLbl->setFont("system_15_fnt");
            m_messageLbl->setTextAlignment("CENTER|MIDDLE");
            attach(m_messageLbl);

            Button * btn = new Button();
            btn->setRect(0, 0, width, height);
            btn->setAlignment("CENTER|MIDDLE", 0, 0);
            btn->addCallback("MouseUp_Left", this, &NotificationDialog::onCloseBtnClick);
            attach(btn);

            setRect(0, 0, width, height);
            setModal(true);
        }

        virtual ~NotificationDialog()
        {
        }

        void setMessage(const std::string & msg)
        {
            if (m_messageLbl)
            {
                m_messageLbl->setText(msg);
            }
        }

        void onCloseBtnClick(Widget * sender)
        {
            view(false);
        }
    }; 

    class MapEditorEditEntityDialog: public Dialog 
    {
    private:
        size_t m_maxSlots;
        std::vector<Container *> m_containers;
    public:
        MapEditorEditEntityDialog(const std::string & id = String::kEmpty)
            : Dialog(id)
            , m_maxSlots(12)
        {   
            Transform openTransform;
            openTransform.add(0, 255, 500);
            attachTransform("WidgetOpening", openTransform);

            Transform closeTransform;
            closeTransform.add(255, 0, 500);
            attachTransform("WidgetClosing", closeTransform);

            setModal(true);
            setRect(0, 0, 500, 700);
            setAlignment("CENTER|MIDDLE", 0, 0);

            Image * img = new Image();
            img->setRect(0, 0, 500, 700);
            img->setSprite("dark_img_spr");
            attach(img);

            Button * okBtn = new Button("okBtn");
            okBtn->setRect(100, 636, 64, 64);
            okBtn->setText("Ok");
            okBtn->setColour("white");
            okBtn->setFont("system_15_fnt");
            okBtn->setTextAlignment("CENTER|MIDDLE");
            okBtn->setSprits("up_btn_spr", "down_btn_spr", "over_btn_spr");
            okBtn->addCallback("MouseUp_Left", this, &MapEditorEditEntityDialog::onOkBtnClick);
            attach(okBtn);

            Button * cancelBtn = new Button("cancelBtn");
            cancelBtn->setRect(336, 636, 64, 64);
            cancelBtn->setText("Cancel");
            cancelBtn->setColour("white");
            cancelBtn->setFont("system_15_fnt");
            cancelBtn->setTextAlignment("CENTER|MIDDLE");
            cancelBtn->setSprits("up_btn_spr", "down_btn_spr", "over_btn_spr");
            cancelBtn->addCallback("MouseUp_Left", this, &MapEditorEditEntityDialog::onCancelBtnClick);
            attach(cancelBtn);

            Label * lbl = new Label();
            lbl->setRect(0, 10, 500, 15);
            lbl->setText("Edit Settings");
            lbl->setColour("red");
            lbl->setFont("system_15_fnt");
            attach(lbl);

            for (size_t i = 0; i < m_maxSlots; ++i)
            {
                Container * cnt = new Container();
                attach(cnt);

                Label * slotNameLbl = new Label("slotNameLbl");
                slotNameLbl->setRect(10, 50 + i * 20, 100, 15);
                slotNameLbl->setFont("system_15_fnt");
                slotNameLbl->setColour("blue");
                slotNameLbl->setTextAlignment("LEFT|MIDDLE");
                cnt->attach(slotNameLbl);

                TextEdit * curValueInput = new TextEdit("curValueInput");
                curValueInput->setRect(115, 50 + i * 20, 50, 15);
                curValueInput->setFont("system_15_fnt");
                curValueInput->setColour("white");
                curValueInput->setTextAlignment("LEFT|MIDDLE");
                cnt->attach(curValueInput);

                Label * lbl = new Label();
                lbl->setText("/");
                lbl->setRect(16, 50 + i * 20, 50, 15);
                lbl->setFont("system_15_fnt");
                lbl->setColour("white");
                lbl->setTextAlignment("CENTER|MIDDLE");
                cnt->attach(lbl);

                TextEdit * maxValueInput = new TextEdit("maxValueInput");
                maxValueInput->setRect(215, 50 + i * 20, 50, 15);
                maxValueInput->setFont("system_15_fnt");
                maxValueInput->setColour("white");
                maxValueInput->setTextAlignment("LEFT|MIDDLE");
                cnt->attach(maxValueInput);

                m_containers.push_back(cnt);
            }
        }

        virtual ~MapEditorEditEntityDialog()
        {
        }

        void onOkBtnClick(Widget * sender)
        {
            view(false);
            applyChanges();
        }

        void applyChanges()
        {
            /*
            for i = 1, kMaxSlotsCount do
                local slot_id = string.format(kSlotIdTemplate, i)
                local cnt = self:getUI(slot_id)
                -- if container is opened
                if (cnt and cnt:isOpened()) then
                    for _, param in ipairs(self._params) do
                        local id_lbl = cnt:getUI("slot_name_lbl")
                        if (id_lbl) then
                            local key = id_lbl:getText()
                            -- find a slot that holds the param values
                            if (param[1] == key) then
                                -- if param 2 exists than read current value input
                                if (param[2]) then
                                    local cur_value_input = cnt:getUI("cur_value_input")
                                    local text = cur_value_input and cur_value_input:getText()
                                    if (text) then
                                        param[2] = tonumber(text) or text
                                    end
                                end
                                -- if param 3 exists than read max value input
                                if (param[3]) then
                                    local max_value_input = cnt:getUI("max_value_input")
                                    local text = max_value_input and max_value_input:getText()
                                    if (text) then
                                        param[3] = tonumber(text) or text
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end

            if (self._params) then
                Observer:call("UpdateEntity", self._params)
            end
             */
        }

        void onCancelBtnClick(Widget * sender)
        {
            view(false);
        }

        void tune()
        {
            /*
            self._params = params

            for i = 1, kMaxSlotsCount do
                local slot_id = string.format(kSlotIdTemplate, i)
                local cnt = self:getUI(slot_id)
                if (cnt) then
                    local param = params and params[i]
                    cnt:view(nil ~= param)
                    if (param) then
                        local id_lbl = cnt:getUI("slot_name_lbl")
                        id_lbl:setText(param[1])
                        
                        local cur_value_input = cnt:getUI("cur_value_input")
                        cur_value_input:view(nil ~= param[2])
                        if (param[2]) then
                            cur_value_input:setText(param[2])
                        end

                        local divider_lbl = cnt:getUI("divider_lbl")
                        divider_lbl:view(nil ~= param[3])
                        
                        local max_value_input = cnt:getUI("max_value_input")
                        max_value_input:view(nil ~= param[3])
                        if (param[3]) then
                            max_value_input:setText(param[3])
                        end
                    end
                end
            end
            */
                        
            }
        }
    }; 

    class MapEditorInventoryDialog: public Dialog 
    {
    public:
        MapEditorInventoryDialog(const std::string & id = String::kEmpty)
            : Dialog(id)
        {
        }

        virtual ~MapEditorInventoryDialog()
        {
        }
    }; 

    class MapEditorScreen : public Screen
    {
    private:
        std::string m_currentMapFile;
        std::vector<Observer *> m_observers;
        MapEditorBattlefield * m_battlefield;
        NotificationDialog * m_notificationDlg;
        MapEditorSaveLoadDialog * m_saveLoadDlg;
        MapEditorEditEntityDialog * m_editEntityDlg;
        MapEditorInventoryDialog * m_inventoryDlg; 
        MapEditorEntitiesPanel * m_entitiesPanel;
        MapEditorSelectionPanel * m_selectionPanel;
    public:
        MapEditorScreen(const std::string & id = String::kEmpty)
            : Screen(id)
            , m_battlefield(nullptr)
            , m_notificationDlg(nullptr)
            , m_saveLoadDlg(nullptr)
            , m_editEntityDlg(nullptr)
            , m_inventoryDlg(nullptr)
            , m_entitiesPanel(nullptr)
            , m_selectionPanel(nullptr)
        {
            addCallback("KeyUp_" + HotKeys::Save, this, &MapEditorScreen::quickSaveMap);
            addCallback("KeyUp_" + HotKeys::Load, this, &MapEditorScreen::quickLoadMap);

            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);
            
           
            MapEditorSystemPanel * systemPanel = new MapEditorSystemPanel("systemPanel");
            systemPanel->instantView(false);
            systemPanel->setAlignment("LEFT|BOTTOM", 0, -64);
            attach(systemPanel);

            for (Observer * observer : m_observers)
            {
                systemPanel->addObserver(observer);
            }

            m_battlefield = new MapEditorBattlefield("battlefield");
            attach(m_battlefield);

            m_entitiesPanel = new MapEditorEntitiesPanel("entitiesPanel");
            m_entitiesPanel->addPage(1, Items);
            m_entitiesPanel->addPage(2, Units);
            m_entitiesPanel->addPage(3, Objects);
            m_entitiesPanel->addPage(4, Terrain);
            attach(m_entitiesPanel);

            m_selectionPanel = new MapEditorSelectionPanel("selectionPanel");
            m_selectionPanel->instantView(false);
            attach(m_selectionPanel);

            MapEditorEditPanel * editPanel = new MapEditorEditPanel("editPanel");
            editPanel->setAngles({0, 90, 180, 270});
            editPanel->setFlips({"false", "false", "   "}, {"true", "false", " | "}, {"false", "true", "- -"}, {"true", "true", "-|-"});
            
            editPanel->serOrders(0, 5);
            attach(editPanel);

            MapEditorFiltersPanel * filtersPanel = new MapEditorFiltersPanel("filtersPanel");
            attach(filtersPanel);

            MapEditorInfoPanel * infoPanel = new MapEditorInfoPanel("infoPanel");
            attach(infoPanel);

            m_saveLoadDlg = new MapEditorSaveLoadDialog("saveLoadDlg");
            attach(m_saveLoadDlg);

            m_notificationDlg = new NotificationDialog("notificationDlg");
            attach(m_notificationDlg);

            m_editEntityDlg = new MapEditorEditEntityDialog("editEntityDlg");
            attach(m_editEntityDlg);

            m_inventoryDlg = new MapEditorInventoryDialog("inventoryDlg");
            attach(m_inventoryDlg);

            addListener(RRE_ShowSelectionPanel this, $MapEditorScreen::showSelectionPanel);
            addListener(RRE_ShowInventoryDialog this, $MapEditorScreen::showInventoryDialog);
            addListener(RRE_ShowEditDialog this, $MapEditorScreen::showEditDialog);
            addListener(RRE_ExitScreen this, $MapEditorScreen::exitScreen);
            addListener(RRE_ShowNotification this, $MapEditorScreen::showNotification);
            addListener(RRE_StartNewMap this, $MapEditorScreen::startNewMap);
            addListener(RRE_SaveMap this, $MapEditorScreen::save);
            addListener(RRE_LoadMap this, $MapEditorScreen::load);
        }

    private:
         void startNewMap()
         {
             if (m_battlefield)
             {
                 m_battlefield->clear();
             }
         }

         void showNotification(const std::string & msg)
         {
             if (m_notificationDlg)
             {
                 m_notificationDlg->setMessage(msg);
                 m_notificationDlg->view(true);
             }
         }

         void saveBattlefieldMap(const std::string & filename)
         {
             if (m_battlefield)
             {
                 m_battlefield->saveMap(filename);
             }
         }

         void loadBattlefieldMap(const std::string & filename)
         {
             if (m_battlefield)
             {
                 m_battlefield->loadMap(filename);
             }
         }

         void openSaveDialog()
         {
             if (m_saveLoadDlg && !m_saveLoadDlg->isOpened())
             {
                 m_saveLoadDlg->setFiles(FileSystem::getFilesInFolder(Config::mapFolder));
                 m_saveLoadDlg->switchToSave();
                 m_saveLoadDlg->view(true);
             }
         }

         void openLoadDialog()
         {
             if (m_saveLoadDlg && !m_saveLoadDlg->isOpened())
             {
                 m_saveLoadDlg->setFiles(FileSystem::getFilesInFolder(Config.map_folder));
                 m_saveLoadDlg->switchToLoad();
                 m_saveLoadDlg->view(true);
             }
          }

         void quickSaveMap()
         {
            if (m_currentMapFile.empty())
            {
                openSaveDialog();
            }
            else
            {
                saveBattlefieldMap(filename);
            }
         }

         void save(const std::string & filename)
         {
            if (filename.empty())
            {
                m_currentMapFile = filename;
                saveBattlefieldMap(filename);
            }
            else
            {
                openSaveDialog();
            }
         }

         void quickLoadMap(const std::string & filename)
         {
            load(filename);
         }

         void load(const std::string & filename)
         {
            if (filename.empty())
            {
                openLoadDialog();
            }
            else
            {
                loadBattlefieldMap(filename);
            }
         }

         void showEditDialog()
         {
             if (m_editEntityDlg && !m_editEntityDlg->isOpened())
             {
                 m_editEntityDlg->tune(params);
                 m_editEntityDlg->view(true);
             }
         }

         void showInventoryDialog()
         {
             if (m_inventoryDlg)
             {
                 m_inventoryDlg->tune(content);
                 m_inventoryDlg->view(true);
             }
         }

         void showSelectionPanel()
         {
             if (m_entitiesPanel)
             {
                 m_entitiesPanel->instantView(false);
             }
             if (m_selectionPanel)
             {
                 m_selectionPanel->tune(entities);
                 m_selectionPanel->instantView(true);
             }

         }

         void showEntityPanel()
         {
             if (m_entitiesPanel)
             {
                 m_entitiesPanel->instantView(true);
             }
             if (m_selectionPanel)
             {
                 m_selectionPanel->instantView(false);
             }

         }
    };
