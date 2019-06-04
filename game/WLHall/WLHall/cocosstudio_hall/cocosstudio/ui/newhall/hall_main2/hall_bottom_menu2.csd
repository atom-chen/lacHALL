<GameFile>
  <PropertyGroup Name="hall_bottom_menu2" Type="Node" ID="a8fff366-7109-472f-ab68-12be6e515e41" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="120" Speed="1.0000">
        <Timeline ActionTag="328918168" Property="Position">
          <PointFrame FrameIndex="0" X="62.0000" Y="24.0000">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="60" X="62.0000" Y="24.0000">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="62" X="62.0000" Y="24.0000">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="120" X="62.0000" Y="24.0000">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="328918168" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="60" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="62" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="120" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="328918168" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="60" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="62" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="120" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="328918168" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="60" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="62" Value="249">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="120" Value="145">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="ani_activity" StartIndex="0" EndIndex="120">
          <RenderColor A="255" R="0" G="128" B="128" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="276" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="nd_right" ActionTag="-1466589195" Tag="284" IconVisible="True" LeftMargin="1280.0000" RightMargin="-1280.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="menu_bg" ActionTag="-388356105" Tag="167" IconVisible="False" LeftMargin="-1280.0000" TopMargin="-76.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="51" ColorAngle="90.0000" Scale9Enable="True" LeftEage="48" RightEage="40" TopEage="23" BottomEage="23" Scale9OriginX="48" Scale9OriginY="23" Scale9Width="20" Scale9Height="30" ctype="PanelObjectData">
                <Size X="1280.0000" Y="76.0000" />
                <AnchorPoint ScaleX="1.0000" />
                <Position />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/bottom_bg.png" Plist="hall/hallMenuView2.plist" />
                <SingleColor A="255" R="0" G="0" B="0" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_room" ActionTag="51464843" Tag="285" IconVisible="False" LeftMargin="-347.0000" RightMargin="67.0000" TopMargin="-85.0000" BottomMargin="-7.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="92" RightEage="92" TopEage="20" BottomEage="20" Scale9OriginX="92" Scale9OriginY="20" Scale9Width="96" Scale9Height="52" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="280.0000" Y="92.0000" />
                <AnchorPoint />
                <Position X="-347.0000" Y="-7.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_hyf.png" Plist="hall/hallMenuView2.plist" />
                <PressedFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_hyf.png" Plist="hall/hallMenuView2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_hyf.png" Plist="hall/hallMenuView2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_exchange" ActionTag="-1428965430" Tag="290" IconVisible="False" LeftMargin="-674.9900" RightMargin="550.9900" TopMargin="-59.0000" BottomMargin="11.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="26" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="124.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-612.9900" Y="35.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_lj.png" Plist="hall/hallMenuView2.plist" />
                <PressedFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_lj.png" Plist="hall/hallMenuView2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_lj.png" Plist="hall/hallMenuView2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_activity" ActionTag="447833045" Tag="131" IconVisible="False" LeftMargin="-962.0000" RightMargin="838.0000" TopMargin="-59.0000" BottomMargin="11.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="26" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="124.0000" Y="48.0000" />
                <Children>
                  <AbstractNodeData Name="ani_act" ActionTag="328918168" Alpha="0" Tag="225" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftEage="42" RightEage="42" TopEage="20" BottomEage="20" Scale9OriginX="42" Scale9OriginY="20" Scale9Width="40" Scale9Height="8" ctype="ImageViewObjectData">
                    <Size X="124.0000" Y="48.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="62.0000" Y="24.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_hd2.png" Plist="hall/hallMenuView2.plist" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-900.0000" Y="35.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_hd.png" Plist="hall/hallMenuView2.plist" />
                <PressedFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_hd.png" Plist="hall/hallMenuView2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_hd.png" Plist="hall/hallMenuView2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_notice" ActionTag="-198580334" Tag="2378" IconVisible="False" LeftMargin="-820.3300" RightMargin="696.3300" TopMargin="-59.0000" BottomMargin="11.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="26" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="124.0000" Y="48.0000" />
                <Children>
                  <AbstractNodeData Name="ico_bubble" ActionTag="-1959195554" VisibleForFrame="False" Tag="2379" IconVisible="False" LeftMargin="33.5000" RightMargin="57.5000" TopMargin="-8.0000" BottomMargin="24.0000" Scale9Enable="True" LeftEage="16" RightEage="16" TopEage="16" BottomEage="16" Scale9OriginX="16" Scale9OriginY="16" Scale9Width="1" Scale9Height="1" ctype="ImageViewObjectData">
                    <Size X="33.0000" Y="32.0000" />
                    <Children>
                      <AbstractNodeData Name="txt_msgcnt" ActionTag="1877342665" Tag="2380" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="11.5000" RightMargin="11.5000" TopMargin="6.0000" BottomMargin="6.0000" FontSize="20" LabelText="0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="10.0000" Y="20.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="16.5000" Y="16.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.3030" Y="0.6250" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="50.0000" Y="40.0000" />
                    <Scale ScaleX="0.7700" ScaleY="0.7700" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4032" Y="0.8333" />
                    <PreSize X="0.2661" Y="0.6667" />
                    <FileData Type="MarkedSubImage" Path="hall/common/info_bubble.png" Plist="hall/common.plist" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-758.3300" Y="35.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_yj.png" Plist="hall/hallMenuView2.plist" />
                <PressedFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_yj.png" Plist="hall/hallMenuView2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_yj.png" Plist="hall/hallMenuView2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="img_line4" ActionTag="-1960995484" VisibleForFrame="False" Tag="2949" IconVisible="False" LeftMargin="-972.1099" RightMargin="970.1099" TopMargin="-51.0015" BottomMargin="15.0015" TopEage="11" BottomEage="11" Scale9OriginY="11" Scale9Width="2" Scale9Height="14" ctype="ImageViewObjectData">
                <Size X="2.0000" Y="36.0000" />
                <AnchorPoint ScaleX="-0.2654" ScaleY="0.5061" />
                <Position X="-972.6407" Y="33.2211" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_line.png" Plist="hall/hallMenuView2.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="img_line3" ActionTag="-1554593531" VisibleForFrame="False" Tag="2952" IconVisible="False" LeftMargin="-830.1100" RightMargin="828.1100" TopMargin="-51.0000" BottomMargin="15.0000" TopEage="11" BottomEage="11" Scale9OriginY="11" Scale9Width="2" Scale9Height="14" ctype="ImageViewObjectData">
                <Size X="2.0000" Y="36.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-829.1100" Y="33.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_line.png" Plist="hall/hallMenuView2.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="img_line2" ActionTag="-1844016735" VisibleForFrame="False" Tag="2953" IconVisible="False" LeftMargin="-690.1100" RightMargin="688.1100" TopMargin="-51.0000" BottomMargin="15.0000" TopEage="11" BottomEage="11" Scale9OriginY="11" Scale9Width="2" Scale9Height="14" ctype="ImageViewObjectData">
                <Size X="2.0000" Y="36.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-689.1100" Y="33.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_line.png" Plist="hall/hallMenuView2.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="img_line1" ActionTag="1561757247" VisibleForFrame="False" Tag="2954" IconVisible="False" LeftMargin="-537.1100" RightMargin="535.1100" TopMargin="-51.0000" BottomMargin="15.0000" TopEage="11" BottomEage="11" Scale9OriginY="11" Scale9Width="2" Scale9Height="14" ctype="ImageViewObjectData">
                <Size X="2.0000" Y="36.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-536.1100" Y="33.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/img_line.png" Plist="hall/hallMenuView2.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_shop" ActionTag="-1841352284" Tag="2956" IconVisible="False" LeftMargin="-526.1364" RightMargin="402.1364" TopMargin="-59.0000" BottomMargin="11.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="26" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="124.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-464.1364" Y="35.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_sc.png" Plist="hall/hallMenuView2.plist" />
                <PressedFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_sc.png" Plist="hall/hallMenuView2.plist" />
                <NormalFileData Type="MarkedSubImage" Path="hall/newhall/hall_main2/btn_sc.png" Plist="hall/hallMenuView2.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="1280.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="nd_left" ActionTag="58574545" Tag="297" IconVisible="True" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="nd_honor" ActionTag="-777692949" Tag="299" IconVisible="True" LeftMargin="103.0000" RightMargin="-103.0000" TopMargin="-43.0000" BottomMargin="43.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="img_0" ActionTag="-704086085" Tag="301" IconVisible="False" LeftMargin="-12.0000" RightMargin="-234.0000" TopMargin="-11.5000" BottomMargin="-31.5000" Scale9Enable="True" LeftEage="19" RightEage="19" Scale9OriginX="19" Scale9Width="12" Scale9Height="35" ctype="ImageViewObjectData">
                    <Size X="246.0000" Y="43.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="-12.0000" Y="-10.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="hall/newhall/bg_star.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_1" ActionTag="-1969594314" Tag="300" IconVisible="False" LeftMargin="-33.0000" RightMargin="-29.0000" TopMargin="-22.0001" BottomMargin="-33.9999" LeftEage="32" RightEage="32" TopEage="23" BottomEage="23" Scale9OriginX="30" Scale9OriginY="23" Scale9Width="2" Scale9Height="10" ctype="ImageViewObjectData">
                    <Size X="62.0000" Y="56.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="-2.0000" Y="-5.9999" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="hall/newhall/btn_jbei.png" Plist="hall/newhall.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="star_1" ActionTag="-1458660193" Tag="193" IconVisible="False" LeftMargin="29.0002" RightMargin="-53.0002" TopMargin="-2.5001" BottomMargin="-20.4999" TouchEnable="True" ctype="SliderObjectData">
                    <Size X="24.0000" Y="23.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="41.0002" Y="-8.9999" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <BackGroundData Type="MarkedSubImage" Path="hall/newhall/btn_wjxb.png" Plist="hall/newhall.plist" />
                    <ProgressBarData Type="MarkedSubImage" Path="hall/newhall/btn_wjx.png" Plist="hall/newhall.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="star_2" ActionTag="-1873270471" Tag="197" IconVisible="False" LeftMargin="58.9999" RightMargin="-82.9999" TopMargin="-2.5000" BottomMargin="-20.5000" TouchEnable="True" ctype="SliderObjectData">
                    <Size X="24.0000" Y="23.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="70.9999" Y="-9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <BackGroundData Type="MarkedSubImage" Path="hall/newhall/btn_wjxb.png" Plist="hall/newhall.plist" />
                    <ProgressBarData Type="MarkedSubImage" Path="hall/newhall/btn_wjx.png" Plist="hall/newhall.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="star_3" ActionTag="-258078446" Tag="196" IconVisible="False" LeftMargin="89.9999" RightMargin="-113.9999" TopMargin="-2.5000" BottomMargin="-20.5000" TouchEnable="True" ctype="SliderObjectData">
                    <Size X="24.0000" Y="23.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="101.9999" Y="-9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <BackGroundData Type="MarkedSubImage" Path="hall/newhall/btn_wjxb.png" Plist="hall/newhall.plist" />
                    <ProgressBarData Type="MarkedSubImage" Path="hall/newhall/btn_wjx.png" Plist="hall/newhall.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="star_4" ActionTag="1866053899" Tag="195" IconVisible="False" LeftMargin="118.9996" RightMargin="-142.9996" TopMargin="-2.5000" BottomMargin="-20.5000" TouchEnable="True" ctype="SliderObjectData">
                    <Size X="24.0000" Y="23.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="130.9996" Y="-9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <BackGroundData Type="MarkedSubImage" Path="hall/newhall/btn_wjxb.png" Plist="hall/newhall.plist" />
                    <ProgressBarData Type="MarkedSubImage" Path="hall/newhall/btn_wjx.png" Plist="hall/newhall.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="star_5" ActionTag="-481662459" Tag="194" IconVisible="False" LeftMargin="148.9996" RightMargin="-172.9996" TopMargin="-1.5000" BottomMargin="-21.5000" TouchEnable="True" ctype="SliderObjectData">
                    <Size X="24.0000" Y="23.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="160.9996" Y="-10.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <BackGroundData Type="MarkedSubImage" Path="hall/newhall/btn_wjxb.png" Plist="hall/newhall.plist" />
                    <ProgressBarData Type="MarkedSubImage" Path="hall/newhall/btn_wjx.png" Plist="hall/newhall.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_honor" CanEdit="False" ActionTag="-607667933" Tag="107" IconVisible="False" LeftMargin="-35.0000" RightMargin="-215.0000" TopMargin="-25.5000" BottomMargin="-39.5000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="250.0000" Y="65.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="90.0000" Y="-7.0000" />
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
                <Position X="103.0000" Y="43.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
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
      </ObjectData>
    </Content>
  </Content>
</GameFile>