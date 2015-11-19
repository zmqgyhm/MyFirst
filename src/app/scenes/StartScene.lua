local StartScene = class("StartScene", function()
	return display.newScene("StartScene")
end)

function StartScene:ctor()
	self:init()
end

StartScene.isTime = 1

function StartScene:init()
	--keyPad
	self:setKeypadEnabled(true)
	self:addNodeEventListener(cc.KEYPAD_EVENT , function(event)
		if event.key == "back" then
			if StartScene.isTime==1 then
				self.message = MessageBox.new()
	  			self.message:setPosition(cc.p(0, 0))
				self:addChild(self.message,10)
				StartScene.isTime = 2
			elseif StartScene.isTime==2 then
				if self.message then
					self.message:removeFromParent()
				end
				StartScene.isTime = 1
			end
		elseif event.key == "menu" then
			audio.pauseMusic("backmusic.mp3")
			SetLayer.isPlayMusic = false
		end
	end)

	--背景
	local bg = display.newSprite("bg2.png")
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setPosition(cc.p(display.cx, display.cy))
	self:addChild(bg)

	local png = "hudie.png"
	local plist = "hudie.plist"
	display.addSpriteFrames(plist,png)
	
	--蝴蝶
	self._sp = display.newSprite("#1.png")
	self._sp:setPosition(cc.p(display.right-150, display.top-150))
	self._sp:setScale(2)
	self:addChild(self._sp,1)
	self:startAnimate()

	self._snow = cc.ParticleSnow:create()
	self._snow:setPosition(cc.p(display.cx, display.top))
	self:addChild(self._snow,1,1)


	--开始按钮
	self.startButton = BubbleButton.new({
        image = "play.png",
        x = display.cx,
        y = display.cy+100,
        listener = function(tag)
            local selectScene = SelectScene.new()
			cc.Director:getInstance():replaceScene(selectScene)
			
		end
    })
    self.startButton:setPosition(cc.p(480,400));
    self:addChild(self.startButton,2)

    --设置按钮
    self.setButton = BubbleButton.new({
        image = "set.png",
        x = display.cx,
        y = display.cy,
        listener = function(tag)
            local setLayer = SetLayer.new()
            setLayer:setPosition(cc.p(0, -200))
            self:addChild(setLayer,2)
			transition.moveTo(setLayer, {x = 0, y = 0, time = 0.8})
		end
    })
    self.setButton:setPosition(cc.p(480,300));
    self:addChild(self.setButton,2)

    --帮助按钮
    self.helpButton = BubbleButton.new({
        image = "help.png",
        x = display.cx,
        y = display.cy-100,
        listener = function(tag)
            self:help()
		end
    })
    self.helpButton:setPosition(cc.p(480,200));
    self:addChild(self.helpButton,2)
  
    audio.preloadMusic("backmusic.mp3")
    --自动播放音乐
    if SetLayer.isPlayMusic then
    	audio.playMusic("backmusic.mp3",true)
		audio.setMusicVolume(0.7)
    end

end

--游戏帮助
function StartScene:help()
	self._help = display.newSprite("help_mianban.png")
	self._help:setPosition(cc.p(display.cx, display.cy-200))
	self:addChild(self._help,2)

	transition.moveTo(self._help, {x = display.cx, y = display.cy, time = 0.8})

	local btn = cc.ui.UIPushButton.new({normal = "ok.png"}, {scale9 = true})
	btn:setPosition(cc.p(self._help:getContentSize().width/2, 100))
	self._help:addChild(btn)
	btn:onButtonClicked(function()
		self._help:removeFromParent()
	
		end)
end

function StartScene:startAnimate()
	local frames = display.newFrames("%d.png", 0, 8)
	local animation = display.newAnimation(frames, 0.1)
	local animate=cc.Animate:create(animation)
	self._sp:playAnimationForever(animation, 0.1)
	local moveto1 = cc.MoveTo:create(2, cc.p(display.left+150, display.top-150))
	local moveto2 = cc.MoveTo:create(1, cc.p(260, 260))
	local seq = cc.Sequence:create(moveto1,moveto2)
	local s = cc.Spawn:create(seq,animate)
	self._sp:runAction(s)
end

function StartScene:onEnter()
end

function StartScene:onExit()
	self._snow:removeFromParent()
end


return StartScene