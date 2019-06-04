<GameFile>
  <PropertyGroup Name="probability_pop_view" Type="Node" ID="cacff69f-9429-424a-b136-a4d9df6d26df" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Node" Tag="121" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="panel_bg" ActionTag="146182168" Tag="153" IconVisible="False" LeftMargin="-639.9987" RightMargin="-640.0013" TopMargin="-360.0000" BottomMargin="-360.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="148" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="0.0013" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="255" G="255" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="img_bg" ActionTag="832565239" Tag="122" IconVisible="False" LeftMargin="-220.0000" RightMargin="-220.0000" TopMargin="-200.0000" BottomMargin="-200.0000" TouchEnable="True" Scale9Enable="True" LeftEage="23" RightEage="23" TopEage="89" BottomEage="37" Scale9OriginX="23" Scale9OriginY="89" Scale9Width="1" Scale9Height="1" ctype="ImageViewObjectData">
            <Size X="440.0000" Y="400.0000" />
            <Children>
              <AbstractNodeData Name="txt_title" ActionTag="1625986123" Tag="96" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="156.0000" RightMargin="156.0000" TopMargin="28.5000" BottomMargin="338.5000" FontSize="32" LabelText="抽奖概率" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="128.0000" Y="33.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="220.0000" Y="355.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="235" B="18" />
                <PrePosition X="0.5000" Y="0.8875" />
                <PreSize X="0.2909" Y="0.0825" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="lv_items" ActionTag="993844538" Tag="133" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="20.0000" RightMargin="20.0000" TopMargin="90.0000" BottomMargin="25.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="400.0000" Y="285.0000" />
                <AnchorPoint ScaleX="0.5000" />
                <Position X="220.0000" Y="25.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.0625" />
                <PreSize X="0.9091" Y="0.7125" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="hall/common/item_info_bg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="panel_item" ActionTag="-145716205" VisibleForFrame="False" Tag="19" IconVisible="False" LeftMargin="300.0000" RightMargin="-700.0000" TopMargin="-48.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="178" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="400.0000" Y="48.0000" />
            <Children>
              <AbstractNodeData Name="img_award" ActionTag="-591092412" VisibleForFrame="False" Tag="9" IconVisible="False" RightMargin="352.0000" LeftEage="36" RightEage="36" TopEage="36" BottomEage="36" Scale9OriginX="36" Scale9OriginY="36" Scale9Width="72" Scale9Height="50" ctype="ImageViewObjectData">
                <Size X="48.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="24.0000" Y="24.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0600" Y="0.5000" />
                <PreSize X="0.1200" Y="1.0000" />
                <FileData Type="Normal" Path="common/prop/img_prop_yuanbao.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_award" ActionTag="-32992570" Tag="20" IconVisible="False" LeftMargin="5.0000" RightMargin="347.0000" TopMargin="9.4999" BottomMargin="5.5001" FontSize="32" LabelText="x50" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="48.0000" Y="33.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="5.0000" Y="22.0001" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="95" G="166" B="184" />
                <PrePosition X="0.0125" Y="0.4583" />
                <PreSize X="0.1200" Y="0.6875" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_rate" ActionTag="276443782" Tag="21" IconVisible="False" LeftMargin="352.0000" TopMargin="9.4999" BottomMargin="5.5001" FontSize="32" LabelText="10%" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="48.0000" Y="33.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="400.0000" Y="22.0001" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="160" G="173" B="180" />
                <PrePosition X="1.0000" Y="0.4583" />
                <PreSize X="0.1200" Y="0.6875" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="300.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>