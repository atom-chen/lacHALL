<GameFile>
  <PropertyGroup Name="item_hot" Type="Node" ID="0b118db1-b25c-44c2-8fea-e8d29f441a2c" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="0.7500" ActivedAnimationName="hot_animation">
        <Timeline ActionTag="1589194304" Property="FileData">
          <TextureFrame FrameIndex="0" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_1.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="5" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_2.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="10" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_3.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="15" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_4.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="20" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_5.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="25" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_6.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="30" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_7.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="35" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_8.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="40" Tween="False">
            <TextureFile Type="Normal" Path="hall/room/minigames/hot_action_1.png" Plist="" />
          </TextureFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="hot_animation" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="34" G="139" B="34" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="140" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="img_bg" ActionTag="2030005539" Tag="147" IconVisible="False" LeftMargin="-92.0000" RightMargin="-92.0000" TopMargin="-57.0000" BottomMargin="-57.0000" TouchEnable="True" ClipAble="False" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="184.0000" Y="114.0000" />
            <Children>
              <AbstractNodeData Name="img_icon" ActionTag="-1830155159" Tag="148" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftEage="40" RightEage="40" TopEage="40" BottomEage="40" Scale9OriginX="40" Scale9OriginY="40" Scale9Width="106" Scale9Height="36" ctype="ImageViewObjectData">
                <Size X="184.0000" Y="114.0000" />
                <AnchorPoint ScaleY="1.0000" />
                <Position Y="114.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition Y="1.0000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="Normal" Path="weile/img_moren.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="action_node" ActionTag="1589194304" Tag="141" IconVisible="False" LeftMargin="-57.0000" RightMargin="-59.0000" TopMargin="-45.0000" BottomMargin="-41.0000" ctype="SpriteObjectData">
                <Size X="300.0000" Y="200.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="93.0000" Y="59.0000" />
                <Scale ScaleX="0.7250" ScaleY="0.7900" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5054" Y="0.5175" />
                <PreSize X="1.6304" Y="1.7544" />
                <FileData Type="Normal" Path="hall/room/minigames/hot_action_1.png" Plist="" />
                <BlendFunc Src="770" Dst="1" />
              </AbstractNodeData>
              <AbstractNodeData Name="panel" ActionTag="624373317" VisibleForFrame="False" Tag="114" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Enable="True" LeftEage="13" RightEage="13" TopEage="13" BottomEage="13" Scale9OriginX="13" Scale9OriginY="13" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="184.0000" Y="114.0000" />
                <Children>
                  <AbstractNodeData Name="img_load" ActionTag="-1429540609" Tag="79" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="56.0000" RightMargin="56.0000" TopMargin="21.0000" BottomMargin="21.0000" LeftEage="28" RightEage="28" TopEage="28" BottomEage="28" Scale9OriginX="28" Scale9OriginY="28" Scale9Width="16" Scale9Height="16" ctype="ImageViewObjectData">
                    <Size X="72.0000" Y="72.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="92.0000" Y="57.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.3913" Y="0.6316" />
                    <FileData Type="MarkedSubImage" Path="hall/feedback/shape_b_4.png" Plist="hall/feedback.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="txt" ActionTag="-131369590" Tag="116" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="72.0000" RightMargin="72.0000" TopMargin="47.0000" BottomMargin="47.0000" FontSize="20" LabelText="等待" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="40.0000" Y="20.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="92.0000" Y="57.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.2174" Y="0.1754" />
                    <FontResource Type="Default" Path="" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="92.0000" Y="57.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/img_mask.png" Plist="hall/newhall.plist" />
                <SingleColor A="255" R="0" G="0" B="0" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_name" ActionTag="-1425000865" Tag="37" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="56.0000" RightMargin="56.0000" TopMargin="84.0000" BottomMargin="12.0000" FontSize="18" LabelText="红包比赛" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="72.0000" Y="18.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="92.0000" Y="21.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="30" G="47" B="64" />
                <PrePosition X="0.5000" Y="0.1842" />
                <PreSize X="0.3913" Y="0.1579" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_min" ActionTag="969989457" VisibleForFrame="False" Tag="72" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="56.0000" RightMargin="56.0000" TopMargin="91.0000" BottomMargin="5.0000" FontSize="18" LabelText="1000豆入" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="72.0000" Y="18.0000" />
                <Children>
                  <AbstractNodeData Name="img_line_1" ActionTag="-206710751" Tag="48" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="-19.0000" RightMargin="72.0000" TopMargin="8.0000" BottomMargin="8.0000" ctype="SpriteObjectData">
                    <Size X="19.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position Y="9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="0.5000" />
                    <PreSize X="0.2639" Y="0.1111" />
                    <FileData Type="MarkedSubImage" Path="hall/newgamelist/img_item_line.png" Plist="hall/gmaelist.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_line_2" ActionTag="2025765535" Tag="49" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="72.0000" RightMargin="-19.0000" TopMargin="8.0000" BottomMargin="8.0000" FlipX="True" ctype="SpriteObjectData">
                    <Size X="19.0000" Y="2.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="72.0000" Y="9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0000" Y="0.5000" />
                    <PreSize X="0.2639" Y="0.1111" />
                    <FileData Type="MarkedSubImage" Path="hall/newgamelist/img_item_line.png" Plist="hall/gmaelist.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="92.0000" Y="14.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.1228" />
                <PreSize X="0.3913" Y="0.1579" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="img_min" ActionTag="-276505913" VisibleForFrame="False" Tag="185" IconVisible="False" RightMargin="123.0000" TopMargin="16.0000" BottomMargin="78.0000" Scale9Enable="True" LeftEage="7" RightEage="13" Scale9OriginX="7" Scale9Width="3" Scale9Height="27" ctype="ImageViewObjectData">
                <Size X="61.0000" Y="20.0000" />
                <Children>
                  <AbstractNodeData Name="txt_min_1" ActionTag="-1907111451" Tag="186" IconVisible="False" PositionPercentYEnabled="True" RightMargin="7.0000" TopMargin="3.5000" BottomMargin="3.5000" FontSize="13" LabelText="1000豆入" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="54.0000" Y="13.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position Y="10.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="0.5000" />
                    <PreSize X="0.8852" Y="0.6500" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position Y="88.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition Y="0.7719" />
                <PreSize X="0.3315" Y="0.1754" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/img_di.png" Plist="hall/newhall.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="255" G="255" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>