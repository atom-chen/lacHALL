<GameFile>
  <PropertyGroup Name="uidialcommon" Type="Node" ID="2716652f-7e39-460a-aaa4-a55507e8bb92" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="1.0000" ActivedAnimationName="getaward">
        <Timeline ActionTag="-858298168" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="225.0000">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="15" X="0.0000" Y="225.0000">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="-858298168" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="15" X="1.2000" Y="1.2000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="40" X="1.8000" Y="1.8000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-858298168" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="15" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-858298168" Property="Alpha">
          <IntFrame FrameIndex="0" Value="25">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="15" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="40" Value="0">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="-858298168" Property="CColor">
          <ColorFrame FrameIndex="15" Alpha="255">
            <EasingData Type="0" />
            <Color A="255" R="255" G="255" B="65" />
          </ColorFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="getaward" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="255" G="248" B="220" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="13" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="img_bg" ActionTag="1818699306" Tag="119" IconVisible="False" LeftMargin="-112.0000" RightMargin="-562.0000" TopMargin="-249.5000" BottomMargin="-295.5000" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="20" BottomEage="85" Scale9OriginX="15" Scale9OriginY="20" Scale9Width="1" Scale9Height="1" ctype="ImageViewObjectData">
            <Size X="674.0000" Y="545.0000" />
            <Children>
              <AbstractNodeData Name="img_line" ActionTag="-1728861861" Tag="461" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="124.0000" TopMargin="115.0000" BottomMargin="428.0000" Scale9Enable="True" LeftEage="1" RightEage="1" Scale9OriginX="1" Scale9Width="2" Scale9Height="1" ctype="ImageViewObjectData">
                <Size X="550.0000" Y="2.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="674.0000" Y="429.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0000" Y="0.7872" />
                <PreSize X="0.8160" Y="0.0037" />
                <FileData Type="MarkedSubImage" Path="hall/common/new_line.png" Plist="hall/common.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="img_xydzp" ActionTag="-138859781" Tag="146" IconVisible="False" LeftMargin="10.5000" RightMargin="30.5000" TopMargin="-34.0000" BottomMargin="493.0000" LeftEage="208" RightEage="208" TopEage="28" BottomEage="28" Scale9OriginX="208" Scale9OriginY="28" Scale9Width="217" Scale9Height="30" ctype="ImageViewObjectData">
                <Size X="633.0000" Y="86.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="327.0000" Y="536.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4852" Y="0.9835" />
                <PreSize X="0.9392" Y="0.1578" />
                <FileData Type="MarkedSubImage" Path="hall/lotto/title_xydzp.png" Plist="hall/lotto.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="nd_yb" ActionTag="-795214526" Tag="538" IconVisible="True" RightMargin="674.0000" TopMargin="545.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="img_prop_bg_1" ActionTag="1206030012" Tag="422" IconVisible="False" LeftMargin="216.0000" RightMargin="-358.0000" TopMargin="-472.0000" BottomMargin="438.0000" Scale9Enable="True" LeftEage="21" RightEage="21" TopEage="10" BottomEage="10" Scale9OriginX="21" Scale9OriginY="10" Scale9Width="2" Scale9Height="13" ctype="ImageViewObjectData">
                    <Size X="142.0000" Y="34.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_yb_cnt" ActionTag="878628441" Tag="117" IconVisible="False" LeftMargin="55.0000" RightMargin="39.0000" TopMargin="7.0000" BottomMargin="3.0000" FontSize="24" LabelText="1000" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="48.0000" Y="24.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="55.0000" Y="15.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3873" Y="0.4412" />
                        <PreSize X="0.3380" Y="0.7059" />
                        <FontResource Type="Default" Path="" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="img_prop" ActionTag="-1173612861" Tag="365" IconVisible="False" LeftMargin="-5.0000" RightMargin="77.0000" TopMargin="-18.0000" BottomMargin="-18.0000" ctype="SpriteObjectData">
                        <Size X="70.0000" Y="70.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="17.0000" />
                        <Scale ScaleX="0.6500" ScaleY="0.6500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2113" Y="0.5000" />
                        <PreSize X="0.4930" Y="2.0588" />
                        <FileData Type="Normal" Path="hall/common/prop_lpq_s.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="216.0000" Y="455.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/lotto/bg_shul.png" Plist="hall/lotto.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_prop_bg_2" ActionTag="1182476026" Tag="423" IconVisible="False" LeftMargin="364.0000" RightMargin="-506.0000" TopMargin="-472.0000" BottomMargin="438.0000" Scale9Enable="True" LeftEage="21" RightEage="21" TopEage="10" BottomEage="10" Scale9OriginX="21" Scale9OriginY="10" Scale9Width="2" Scale9Height="13" ctype="ImageViewObjectData">
                    <Size X="142.0000" Y="34.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_hf_cnt" ActionTag="-135950761" Tag="120" IconVisible="False" LeftMargin="55.0000" RightMargin="39.0000" TopMargin="7.0000" BottomMargin="3.0000" FontSize="24" LabelText="1000" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="48.0000" Y="24.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="55.0000" Y="15.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3873" Y="0.4412" />
                        <PreSize X="0.3380" Y="0.7059" />
                        <FontResource Type="Default" Path="" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="img_prop" ActionTag="611201066" Tag="366" IconVisible="False" LeftMargin="-5.0000" RightMargin="77.0000" TopMargin="-18.0000" BottomMargin="-18.0000" ctype="SpriteObjectData">
                        <Size X="70.0000" Y="70.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="17.0000" />
                        <Scale ScaleX="0.6500" ScaleY="0.6500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2113" Y="0.5000" />
                        <PreSize X="0.4930" Y="2.0588" />
                        <FileData Type="Normal" Path="hall/common/prop_hfq_s.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="364.0000" Y="455.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/lotto/bg_shul.png" Plist="hall/lotto.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_prop_bg_3" ActionTag="-1748708907" Tag="424" IconVisible="False" LeftMargin="512.0000" RightMargin="-654.0000" TopMargin="-472.0000" BottomMargin="438.0000" Scale9Enable="True" LeftEage="21" RightEage="21" TopEage="10" BottomEage="10" Scale9OriginX="21" Scale9OriginY="10" Scale9Width="2" Scale9Height="13" ctype="ImageViewObjectData">
                    <Size X="142.0000" Y="34.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_hb_cnt" ActionTag="363055204" Tag="122" IconVisible="False" LeftMargin="55.0000" RightMargin="39.0000" TopMargin="7.0000" BottomMargin="3.0000" FontSize="24" LabelText="1000" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="48.0000" Y="24.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="55.0000" Y="15.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3873" Y="0.4412" />
                        <PreSize X="0.3380" Y="0.7059" />
                        <FontResource Type="Default" Path="" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="img_prop" ActionTag="-539097668" Tag="367" IconVisible="False" LeftMargin="-5.0000" RightMargin="77.0000" TopMargin="-18.0000" BottomMargin="-18.0000" ctype="SpriteObjectData">
                        <Size X="70.0000" Y="70.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="17.0000" />
                        <Scale ScaleX="0.6500" ScaleY="0.6500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2113" Y="0.5000" />
                        <PreSize X="0.4930" Y="2.0588" />
                        <FileData Type="Normal" Path="hall/common/prop_hbq_s.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="512.0000" Y="455.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/lotto/bg_shul.png" Plist="hall/lotto.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_1" ActionTag="-388611432" Tag="1001" IconVisible="False" LeftMargin="110.0000" RightMargin="-280.0000" TopMargin="-47.0000" BottomMargin="-3.0000" TouchEnable="True" ClipAble="False" ColorAngle="90.0000" LeftEage="73" RightEage="73" TopEage="25" BottomEage="25" Scale9OriginX="-73" Scale9OriginY="-25" Scale9Width="146" Scale9Height="50" ctype="PanelObjectData">
                    <Size X="170.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_1" ActionTag="1804091651" Tag="754" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="36.0000" RightMargin="2.0000" TopMargin="14.0000" BottomMargin="14.0000" FontSize="22" LabelText="300礼品券/次" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="132.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="36.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2118" Y="0.5000" />
                        <PreSize X="0.7765" Y="0.4400" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_com" ActionTag="-126727182" Tag="544" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="3.0000" RightMargin="137.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="12" RightEage="12" TopEage="12" BottomEage="12" Scale9OriginX="12" Scale9OriginY="12" Scale9Width="6" Scale9Height="8" ctype="ImageViewObjectData">
                        <Size X="30.0000" Y="32.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="18.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1059" Y="0.5000" />
                        <PreSize X="0.1765" Y="0.6400" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/cb_com.png" Plist="hall/lotto.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_sel" ActionTag="1942077037" Tag="370" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="3.0000" RightMargin="137.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="13" RightEage="13" TopEage="10" BottomEage="10" Scale9OriginX="13" Scale9OriginY="10" Scale9Width="4" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="30.0000" Y="32.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="18.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1059" Y="0.5000" />
                        <PreSize X="0.1765" Y="0.6400" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/cb_sel.png" Plist="hall/lotto.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="280.0000" Y="22.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_2" ActionTag="1702798678" Tag="1002" IconVisible="False" LeftMargin="285.9998" RightMargin="-465.9998" TopMargin="-47.0000" BottomMargin="-3.0000" TouchEnable="True" ClipAble="False" ColorAngle="90.0000" LeftEage="73" RightEage="73" TopEage="25" BottomEage="25" Scale9OriginX="-73" Scale9OriginY="-25" Scale9Width="146" Scale9Height="50" ctype="PanelObjectData">
                    <Size X="180.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_1" ActionTag="-1639130368" Tag="757" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="46.0000" RightMargin="2.0000" TopMargin="14.0000" BottomMargin="14.0000" FontSize="22" LabelText="1元话费券/次" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="132.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="46.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2556" Y="0.5000" />
                        <PreSize X="0.7333" Y="0.4400" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_com" ActionTag="1530227334" Tag="545" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.0000" RightMargin="140.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="12" RightEage="12" TopEage="12" BottomEage="12" Scale9OriginX="12" Scale9OriginY="12" Scale9Width="6" Scale9Height="8" ctype="ImageViewObjectData">
                        <Size X="30.0000" Y="32.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="25.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1389" Y="0.5000" />
                        <PreSize X="0.1667" Y="0.6400" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/cb_com.png" Plist="hall/lotto.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_sel" ActionTag="-529115345" VisibleForFrame="False" Tag="760" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.0000" RightMargin="140.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="13" RightEage="13" TopEage="10" BottomEage="10" Scale9OriginX="13" Scale9OriginY="10" Scale9Width="4" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="30.0000" Y="32.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="25.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1389" Y="0.5000" />
                        <PreSize X="0.1667" Y="0.6400" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/cb_sel.png" Plist="hall/lotto.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="465.9998" Y="22.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_3" ActionTag="-969001082" Tag="1003" IconVisible="False" LeftMargin="475.9999" RightMargin="-655.9999" TopMargin="-47.0000" BottomMargin="-3.0000" TouchEnable="True" ClipAble="False" ColorAngle="90.0000" LeftEage="73" RightEage="73" TopEage="25" BottomEage="25" Scale9OriginX="-73" Scale9OriginY="-25" Scale9Width="146" Scale9Height="50" ctype="PanelObjectData">
                    <Size X="180.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_1" ActionTag="1858114055" Tag="762" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="46.0000" RightMargin="2.0000" TopMargin="14.0000" BottomMargin="14.0000" FontSize="22" LabelText="1元红包券/次" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="132.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="46.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2556" Y="0.5000" />
                        <PreSize X="0.7333" Y="0.4400" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_com" ActionTag="1443290318" Tag="546" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.0000" RightMargin="140.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="12" RightEage="12" TopEage="12" BottomEage="12" Scale9OriginX="12" Scale9OriginY="12" Scale9Width="6" Scale9Height="8" ctype="ImageViewObjectData">
                        <Size X="30.0000" Y="32.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="25.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1389" Y="0.5000" />
                        <PreSize X="0.1667" Y="0.6400" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/cb_com.png" Plist="hall/lotto.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_sel" ActionTag="-882728708" VisibleForFrame="False" Tag="765" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.0000" RightMargin="140.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="13" RightEage="13" TopEage="10" BottomEage="10" Scale9OriginX="13" Scale9OriginY="10" Scale9Width="4" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="30.0000" Y="32.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="25.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1389" Y="0.5000" />
                        <PreSize X="0.1667" Y="0.6400" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/cb_sel.png" Plist="hall/lotto.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="655.9999" Y="22.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_detail" ActionTag="623502332" Tag="135" IconVisible="False" LeftMargin="579.5000" RightMargin="-652.5000" TopMargin="-420.0000" BottomMargin="388.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="43" Scale9Height="10" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="73.0000" Y="32.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="616.0000" Y="404.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="MarkedSubImage" Path="hall/lotto/img_rule.png" Plist="hall/lotto.plist" />
                    <PressedFileData Type="MarkedSubImage" Path="hall/lotto/img_rule.png" Plist="hall/lotto.plist" />
                    <NormalFileData Type="MarkedSubImage" Path="hall/lotto/img_rule.png" Plist="hall/lotto.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="nd_dial" ActionTag="-228584829" Tag="132" IconVisible="False" LeftMargin="-125.0000" RightMargin="799.0000" TopMargin="252.0000" BottomMargin="293.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="node_bg" ActionTag="1885598722" Tag="23" IconVisible="True" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="img_bg_circle" ActionTag="-2099765088" Tag="108" IconVisible="False" LeftMargin="-332.5000" RightMargin="-332.5000" TopMargin="-332.5000" BottomMargin="-332.5000" LeftEage="219" RightEage="219" TopEage="219" BottomEage="219" Scale9OriginX="219" Scale9OriginY="219" Scale9Width="227" Scale9Height="227" ctype="ImageViewObjectData">
                        <Size X="665.0000" Y="665.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="hall/lotto/zp_bg.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_light_1" ActionTag="-1656246139" Tag="27" IconVisible="True" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="spr_light_1" ActionTag="444624245" Tag="28" IconVisible="False" LeftMargin="4.0000" RightMargin="-16.0000" TopMargin="-321.5000" BottomMargin="310.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="10.0000" Y="316.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_1" ActionTag="-209084772" Tag="35" IconVisible="False" LeftMargin="204.0001" RightMargin="-216.0001" TopMargin="-241.5000" BottomMargin="230.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="210.0001" Y="236.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_2" ActionTag="1135735604" Tag="36" IconVisible="False" LeftMargin="307.0000" RightMargin="-319.0000" TopMargin="-45.5000" BottomMargin="34.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="313.0000" Y="40.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_3" ActionTag="-1447473270" Tag="37" IconVisible="False" LeftMargin="263.0000" RightMargin="-275.0000" TopMargin="155.5000" BottomMargin="-166.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="269.0000" Y="-161.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_4" ActionTag="607653111" Tag="41" IconVisible="False" LeftMargin="94.0000" RightMargin="-106.0000" TopMargin="290.5000" BottomMargin="-301.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="100.0000" Y="-296.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_5" ActionTag="-690952041" Tag="111" IconVisible="False" LeftMargin="-123.0000" RightMargin="111.0000" TopMargin="285.5000" BottomMargin="-296.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-117.0000" Y="-291.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_6" ActionTag="1964428349" Tag="43" IconVisible="False" LeftMargin="-282.0000" RightMargin="270.0000" TopMargin="145.5000" BottomMargin="-156.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-276.0000" Y="-151.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_7" ActionTag="-86256671" Tag="112" IconVisible="False" LeftMargin="-315.0000" RightMargin="303.0000" TopMargin="-69.5000" BottomMargin="58.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-309.0000" Y="64.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_8" ActionTag="-469736697" Tag="110" IconVisible="False" LeftMargin="-196.0000" RightMargin="184.0000" TopMargin="-258.5000" BottomMargin="247.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-190.0000" Y="253.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_light_2" ActionTag="353672350" Tag="44" IconVisible="True" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="spr_light_1" ActionTag="-1200823272" Tag="45" IconVisible="False" LeftMargin="105.0000" RightMargin="-117.0000" TopMargin="-302.5000" BottomMargin="291.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="111.0000" Y="297.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_1" ActionTag="-171286005" Tag="47" IconVisible="False" LeftMargin="272.0000" RightMargin="-284.0000" TopMargin="-155.5000" BottomMargin="144.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="278.0000" Y="150.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_2" ActionTag="-312005076" Tag="48" IconVisible="False" LeftMargin="303.0000" RightMargin="-315.0000" TopMargin="53.5000" BottomMargin="-64.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="309.0000" Y="-59.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_3" ActionTag="534764784" Tag="49" IconVisible="False" LeftMargin="192.0000" RightMargin="-204.0000" TopMargin="239.5000" BottomMargin="-250.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="198.0000" Y="-245.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_4" ActionTag="-956474090" Tag="50" IconVisible="False" LeftMargin="-15.8116" RightMargin="3.8116" TopMargin="307.6507" BottomMargin="-318.6507" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-9.8116" Y="-313.1507" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_5" ActionTag="-1863842099" Tag="114" IconVisible="False" LeftMargin="-213.0000" RightMargin="201.0000" TopMargin="233.5000" BottomMargin="-244.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-207.0000" Y="-239.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_6" ActionTag="-1103668446" Tag="52" IconVisible="False" LeftMargin="-319.0000" RightMargin="307.0000" TopMargin="43.5000" BottomMargin="-54.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-313.0000" Y="-49.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_7" ActionTag="-1159376550" Tag="115" IconVisible="False" LeftMargin="-275.0000" RightMargin="263.0000" TopMargin="-173.5000" BottomMargin="162.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-269.0000" Y="168.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_light_1_8" ActionTag="949198079" Tag="113" IconVisible="False" LeftMargin="-111.0000" RightMargin="99.0000" TopMargin="-305.5000" BottomMargin="294.5000" ctype="SpriteObjectData">
                            <Size X="12.0000" Y="11.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-105.0000" Y="300.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/yb_dial_pic_frame_lamp.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_close" ActionTag="1414281987" Tag="698" IconVisible="False" LeftMargin="742.5000" RightMargin="-821.5000" TopMargin="-279.5000" BottomMargin="200.5000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="49" Scale9Height="57" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="79.0000" Y="79.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="782.0000" Y="240.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="MarkedSubImage" Path="hall/lotto/com_btn_close.png" Plist="hall/lotto.plist" />
                        <PressedFileData Type="MarkedSubImage" Path="hall/lotto/com_btn_close.png" Plist="hall/lotto.plist" />
                        <NormalFileData Type="MarkedSubImage" Path="hall/lotto/com_btn_close.png" Plist="hall/lotto.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_dial" ActionTag="-796135591" Tag="54" RotationSkewX="1.0000" RotationSkewY="1.0000" IconVisible="True" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="img_zp" ActionTag="-1236263363" Tag="345" IconVisible="False" LeftMargin="-299.5000" RightMargin="-299.5000" TopMargin="-299.5000" BottomMargin="-299.5000" LeftEage="202" RightEage="202" TopEage="197" BottomEage="197" Scale9OriginX="202" Scale9OriginY="197" Scale9Width="195" Scale9Height="205" ctype="ImageViewObjectData">
                        <Size X="599.0000" Y="599.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="hall/lotto/zp.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_1" ActionTag="131279805" Tag="55" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_2" ActionTag="1373102467" Tag="60" RotationSkewX="40.0000" RotationSkewY="40.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_3" ActionTag="-56511031" Tag="65" RotationSkewX="80.0000" RotationSkewY="80.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_4" ActionTag="682438293" Tag="98" RotationSkewX="120.0000" RotationSkewY="120.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_5" ActionTag="385140212" Tag="102" RotationSkewX="160.0000" RotationSkewY="160.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_6" ActionTag="2004938299" Tag="106" RotationSkewX="200.0000" RotationSkewY="200.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_7" ActionTag="-2066754705" Tag="122" RotationSkewX="240.0000" RotationSkewY="240.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_8" ActionTag="872509805" Tag="126" RotationSkewX="280.0000" RotationSkewY="280.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_dialitem_9" ActionTag="325262338" Tag="221" RotationSkewX="320.0000" RotationSkewY="320.0000" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ui/luckybag/uidialitem.csd" Plist="" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="spr_cur_award" ActionTag="-858298168" Alpha="25" Tag="1047" IconVisible="False" LeftMargin="-108.5000" RightMargin="-108.5000" TopMargin="-314.5000" BottomMargin="135.5000" ctype="SpriteObjectData">
                    <Size X="217.0000" Y="179.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position Y="225.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="65" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/lotto/dial_dh.png" Plist="hall/lotto.plist" />
                    <BlendFunc Src="770" Dst="1" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_front" ActionTag="1765959400" Tag="108" IconVisible="True" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="spr_arrow" ActionTag="780466622" Tag="109" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-23.5000" RightMargin="-23.5000" TopMargin="-138.0000" BottomMargin="65.0000" ctype="SpriteObjectData">
                        <Size X="47.0000" Y="73.0000" />
                        <AnchorPoint ScaleX="0.5000" />
                        <Position Y="65.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="hall/lotto/dial_pic_zz.png" Plist="hall/lotto.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_click" ActionTag="2042019835" Tag="130" IconVisible="False" LeftMargin="-92.0000" RightMargin="-92.0000" TopMargin="-92.0000" BottomMargin="-92.0000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="162" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="184.0000" Y="184.0000" />
                        <Children>
                          <AbstractNodeData Name="spr_word_click_1" ActionTag="1942005976" Tag="110" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="46.5000" RightMargin="46.5000" TopMargin="45.0000" BottomMargin="45.0000" ctype="SpriteObjectData">
                            <Size X="91.0000" Y="94.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="92.0000" Y="92.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="0.5000" />
                            <PreSize X="0.4946" Y="0.5109" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/dial_pic_dwcj_1.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="spr_word_click_2" ActionTag="-1320088396" Tag="199" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="46.5000" RightMargin="46.5000" TopMargin="45.0000" BottomMargin="45.0000" ctype="SpriteObjectData">
                            <Size X="91.0000" Y="94.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="92.0000" Y="92.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="0.5000" />
                            <PreSize X="0.4946" Y="0.5109" />
                            <FileData Type="MarkedSubImage" Path="hall/lotto/dial_pic_dwcj_2.png" Plist="hall/lotto.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="MarkedSubImage" Path="hall/lotto/dial_btn_3.png" Plist="hall/lotto.plist" />
                        <PressedFileData Type="MarkedSubImage" Path="hall/lotto/dial_btn_2.png" Plist="hall/lotto.plist" />
                        <NormalFileData Type="MarkedSubImage" Path="hall/lotto/dial_btn_1.png" Plist="hall/lotto.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="-125.0000" Y="293.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.1855" Y="0.5376" />
                <PreSize X="0.0000" Y="0.0000" />
                <SingleColor A="255" R="0" G="0" B="0" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="nd_record" ActionTag="-1569061076" Tag="836" IconVisible="True" RightMargin="674.0000" TopMargin="545.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="txt_title" ActionTag="1557755795" Tag="837" IconVisible="False" LeftMargin="379.0000" RightMargin="-475.0000" TopMargin="-416.0000" BottomMargin="392.0000" FontSize="24" LabelText="获奖记录" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="96.0000" Y="24.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="427.0000" Y="404.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="202" G="128" B="63" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_l" CanEdit="False" ActionTag="1979346580" Tag="839" IconVisible="False" LeftMargin="343.0000" RightMargin="-361.0000" TopMargin="-411.0000" BottomMargin="393.0000" LeftEage="5" RightEage="5" TopEage="5" BottomEage="5" Scale9OriginX="5" Scale9OriginY="5" Scale9Width="8" Scale9Height="8" ctype="ImageViewObjectData">
                    <Size X="18.0000" Y="18.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="361.0000" Y="402.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/lotto/logo.png" Plist="hall/lotto.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_r" CanEdit="False" ActionTag="2119692755" Tag="840" IconVisible="False" LeftMargin="490.0000" RightMargin="-508.0000" TopMargin="-411.0000" BottomMargin="393.0000" LeftEage="5" RightEage="5" TopEage="5" BottomEage="5" Scale9OriginX="5" Scale9OriginY="5" Scale9Width="8" Scale9Height="8" ctype="ImageViewObjectData">
                    <Size X="18.0000" Y="18.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="490.0000" Y="402.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/lotto/logo.png" Plist="hall/lotto.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="panel_record" ActionTag="-406362411" Tag="838" IconVisible="False" LeftMargin="205.0000" RightMargin="-665.0000" TopMargin="-386.0000" BottomMargin="94.0000" TouchEnable="True" ClipAble="True" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="460.0000" Y="292.0000" />
                    <Children>
                      <AbstractNodeData Name="pv_record" ActionTag="-639172859" Tag="877" IconVisible="False" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" BottomMargin="219.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="0" ctype="PageViewObjectData">
                        <Size X="460.0000" Y="73.0000" />
                        <AnchorPoint ScaleY="1.0000" />
                        <Position Y="292.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition Y="1.0000" />
                        <PreSize X="1.0000" Y="0.2500" />
                        <SingleColor A="255" R="150" G="150" B="100" />
                        <FirstColor A="255" R="150" G="150" B="100" />
                        <EndColor A="255" R="255" G="255" B="255" />
                        <ColorVector ScaleY="1.0000" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="205.0000" Y="94.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" />
            <Position X="225.0000" Y="-295.5000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="hall/lotto/cj_bg.png" Plist="hall/lotto.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="item_record" ActionTag="1488398056" VisibleForFrame="False" Tag="841" IconVisible="False" RightMargin="-460.0000" TopMargin="400.0000" BottomMargin="-473.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="460.0000" Y="73.0000" />
            <Children>
              <AbstractNodeData Name="img_avatar" ActionTag="1120435569" Tag="842" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="14.0000" RightMargin="386.0000" TopMargin="6.5000" BottomMargin="6.5000" LeftEage="32" RightEage="32" TopEage="32" BottomEage="32" Scale9OriginX="32" Scale9OriginY="32" Scale9Width="34" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="44.0000" Y="36.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0957" Y="0.5000" />
                <PreSize X="0.1304" Y="0.8219" />
                <FileData Type="Normal" Path="common/hd_male.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_nick" ActionTag="1914285345" Tag="871" IconVisible="False" LeftMargin="85.0000" RightMargin="295.0000" TopMargin="17.0000" BottomMargin="36.0000" FontSize="20" LabelText="玩家昵称" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="80.0000" Y="20.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="85.0000" Y="46.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="106" G="106" B="106" />
                <PrePosition X="0.1848" Y="0.6301" />
                <PreSize X="0.1739" Y="0.2740" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_id" ActionTag="2115246329" Tag="872" IconVisible="False" LeftMargin="85.0000" RightMargin="294.0000" TopMargin="43.0000" BottomMargin="12.0000" FontSize="18" LabelText="ID.123456" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="81.0000" Y="18.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="85.0000" Y="21.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="106" G="106" B="106" />
                <PrePosition X="0.1848" Y="0.2877" />
                <PreSize X="0.1761" Y="0.2466" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_time" ActionTag="-871156311" Tag="873" IconVisible="False" LeftMargin="282.0000" RightMargin="18.0000" TopMargin="18.0000" BottomMargin="35.0000" FontSize="20" LabelText="2011-11-11 20:30" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="160.0000" Y="20.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="442.0000" Y="45.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="161" G="161" B="161" />
                <PrePosition X="0.9609" Y="0.6164" />
                <PreSize X="0.3478" Y="0.2740" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_cnt" ActionTag="651137009" Tag="875" IconVisible="False" LeftMargin="342.0000" RightMargin="18.0000" TopMargin="41.0000" BottomMargin="12.0000" FontSize="20" LabelText="话费券x3.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="100.0000" Y="20.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="442.0000" Y="22.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="231" G="158" B="31" />
                <PrePosition X="0.9609" Y="0.3014" />
                <PreSize X="0.2174" Y="0.2740" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="1.0000" />
            <Position Y="-400.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>