<GameFile>
  <PropertyGroup Name="hall_main_view" Type="Layer" ID="7eb6a4af-beab-42c1-be11-bbe221d8a0c1" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="192" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="img_girl" ActionTag="-622078042" Tag="350" IconVisible="False" LeftMargin="440.5000" RightMargin="558.5000" TopMargin="117.0000" LeftEage="117" RightEage="117" TopEage="221" BottomEage="221" Scale9OriginX="117" Scale9OriginY="221" Scale9Width="47" Scale9Height="161" ctype="ImageViewObjectData">
            <Size X="281.0000" Y="603.0000" />
            <AnchorPoint ScaleX="0.5000" />
            <Position X="581.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4539" />
            <PreSize X="0.2195" Y="0.8375" />
            <FileData Type="Normal" Path="hall/newhall/hall_main3/renwu.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="nd_btns" ActionTag="-1090398752" Tag="193" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1280.0000" TopMargin="360.0000" BottomMargin="360.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="btn_redpacket" ActionTag="-47142900" Tag="194" IconVisible="False" LeftMargin="-375.0000" RightMargin="17.0000" TopMargin="-241.0000" BottomMargin="123.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="328" Scale9Height="96" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="358.0000" Y="118.0000" />
                <Children>
                  <AbstractNodeData Name="particle_bg" ActionTag="-272578345" Tag="45" IconVisible="False" LeftMargin="4.0000" RightMargin="1.0000" TopMargin="2.0000" BottomMargin="9.0000" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="353.0000" Y="107.0000" />
                    <Children>
                      <AbstractNodeData Name="particle_meihua" ActionTag="1973086507" Tag="42" IconVisible="True" LeftMargin="245.0000" RightMargin="108.0000" TopMargin="82.0000" BottomMargin="25.0000" ctype="ParticleObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="245.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6941" Y="0.2336" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="hall/newhall/hall_main3/Particle_phmeihua.plist" Plist="" />
                        <BlendFunc Src="770" Dst="1" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="4.0000" Y="9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0112" Y="0.0763" />
                    <PreSize X="0.9860" Y="0.9068" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="download_bg" ActionTag="-326422087" VisibleForFrame="False" Tag="137" IconVisible="False" LeftMargin="5.0000" RightMargin="9.0000" TopMargin="4.0000" BottomMargin="10.0000" TouchEnable="True" LeftEage="87" RightEage="87" TopEage="38" BottomEage="38" Scale9OriginX="87" Scale9OriginY="38" Scale9Width="170" Scale9Height="28" ctype="ImageViewObjectData">
                    <Size X="344.0000" Y="104.0000" />
                    <Children>
                      <AbstractNodeData Name="img_gq" ActionTag="-592604895" Tag="135" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="129.0000" RightMargin="129.0000" TopMargin="9.0000" BottomMargin="9.0000" LeftEage="28" RightEage="28" TopEage="28" BottomEage="28" Scale9OriginX="28" Scale9OriginY="28" Scale9Width="30" Scale9Height="30" ctype="ImageViewObjectData">
                        <Size X="86.0000" Y="86.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="172.0000" Y="52.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.2500" Y="0.8269" />
                        <FileData Type="MarkedSubImage" Path="hall/common/loading_circle_bg.png" Plist="hall/common.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="txt_progress" ActionTag="-507724607" Tag="136" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="146.0000" RightMargin="146.0000" TopMargin="35.0000" BottomMargin="43.0000" FontSize="26" LabelText="等待" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="52.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="172.0000" Y="56.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5385" />
                        <PreSize X="0.1512" Y="0.2500" />
                        <FontResource Type="Default" Path="" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="177.0000" Y="62.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4944" Y="0.5254" />
                    <PreSize X="0.9609" Y="0.8814" />
                    <FileData Type="Normal" Path="hall/newhall/hall_main3/btn_qhbzz.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-196.0000" Y="182.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="hall/newhall/hall_main3/btn_qhb.png" Plist="" />
                <PressedFileData Type="Normal" Path="hall/newhall/hall_main3/btn_qhb.png" Plist="" />
                <NormalFileData Type="Normal" Path="hall/newhall/hall_main3/btn_qhb.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_poker" ActionTag="-1513827135" Tag="197" IconVisible="False" LeftMargin="-375.0000" RightMargin="17.0000" TopMargin="-121.0000" BottomMargin="3.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="328" Scale9Height="96" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="358.0000" Y="118.0000" />
                <Children>
                  <AbstractNodeData Name="particle_bg" ActionTag="-1611521862" Tag="46" IconVisible="False" LeftMargin="4.0000" RightMargin="2.0000" TopMargin="2.0000" BottomMargin="9.0000" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="352.0000" Y="107.0000" />
                    <Children>
                      <AbstractNodeData Name="particle_meihua" ActionTag="-1834212997" Tag="47" IconVisible="True" LeftMargin="245.0000" RightMargin="107.0000" TopMargin="82.0000" BottomMargin="25.0000" ctype="ParticleObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="245.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6960" Y="0.2336" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="hall/newhall/hall_main3/Particle_phmeihua.plist" Plist="" />
                        <BlendFunc Src="770" Dst="1" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="4.0000" Y="9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0112" Y="0.0763" />
                    <PreSize X="0.9832" Y="0.9068" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-196.0000" Y="62.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="hall/newhall/hall_main3/btn_pkg.png" Plist="" />
                <PressedFileData Type="Normal" Path="hall/newhall/hall_main3/btn_pkg.png" Plist="" />
                <NormalFileData Type="Normal" Path="hall/newhall/hall_main3/btn_pkg.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_majiang" ActionTag="-324647589" Tag="198" IconVisible="False" LeftMargin="-375.0000" RightMargin="17.0000" TopMargin="-1.0000" BottomMargin="-117.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="328" Scale9Height="96" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="358.0000" Y="118.0000" />
                <Children>
                  <AbstractNodeData Name="particle_bg" ActionTag="134124978" Tag="48" IconVisible="False" LeftMargin="4.0000" RightMargin="2.0000" TopMargin="-8.0000" BottomMargin="9.0000" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="352.0000" Y="117.0000" />
                    <Children>
                      <AbstractNodeData Name="particle_meihua" ActionTag="802705249" Tag="49" IconVisible="True" LeftMargin="245.0000" RightMargin="107.0000" TopMargin="92.0000" BottomMargin="25.0000" ctype="ParticleObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="245.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6960" Y="0.2137" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="hall/newhall/hall_main3/Particle_phmeihua.plist" Plist="" />
                        <BlendFunc Src="770" Dst="1" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="4.0000" Y="9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0112" Y="0.0763" />
                    <PreSize X="0.9832" Y="0.9915" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-196.0000" Y="-58.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="hall/newhall/hall_main3/btn_mjg.png" Plist="" />
                <PressedFileData Type="Normal" Path="hall/newhall/hall_main3/btn_mjg.png" Plist="" />
                <NormalFileData Type="Normal" Path="hall/newhall/hall_main3/btn_mjg.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_mini" ActionTag="1844660336" Tag="44" IconVisible="False" LeftMargin="-333.0000" RightMargin="17.0000" TopMargin="123.0000" BottomMargin="-233.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="286" Scale9Height="88" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="316.0000" Y="110.0000" />
                <Children>
                  <AbstractNodeData Name="particle_bg" ActionTag="1563316293" Tag="45" IconVisible="False" LeftMargin="4.0000" RightMargin="8.0000" TopMargin="5.0000" BottomMargin="9.0000" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="304.0000" Y="96.0000" />
                    <Children>
                      <AbstractNodeData Name="particle_meihua" ActionTag="-230297142" Tag="46" IconVisible="True" LeftMargin="213.0000" RightMargin="91.0000" TopMargin="71.0000" BottomMargin="25.0000" ctype="ParticleObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="213.0000" Y="25.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7007" Y="0.2604" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="hall/newhall/hall_main3/Particle_phmeihua.plist" Plist="" />
                        <BlendFunc Src="770" Dst="1" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="4.0000" Y="9.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0127" Y="0.0818" />
                    <PreSize X="0.9620" Y="0.8727" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="img_xing" ActionTag="301298592" VisibleForFrame="False" Tag="478" IconVisible="False" LeftMargin="258.8513" RightMargin="23.1487" TopMargin="2.3020" BottomMargin="67.6980" ctype="SpriteObjectData">
                    <Size X="34.0000" Y="40.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="275.8513" Y="87.6980" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8729" Y="0.7973" />
                    <PreSize X="0.1076" Y="0.3636" />
                    <FileData Type="MarkedSubImage" Path="hall/newgamelist/img_xing.png" Plist="hall/gmaelist.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-175.0000" Y="-178.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="hall/newhall/hall_main3/btn_hlg.png" Plist="" />
                <PressedFileData Type="Normal" Path="hall/newhall/hall_main3/btn_hlg.png" Plist="" />
                <NormalFileData Type="Normal" Path="hall/newhall/hall_main3/btn_hlg.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="1280.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.0000" Y="0.5000" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>