﻿unit Principal;

interface

uses
  {Androidapi.JNI.Location,} System.Sensors.Components, System.DateUtils, System.Math,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, System.Sensors{, UTM_WGS84},
  UtilesVelox;

type
  TFPrinc = class(TForm)
    LayPrinc: TLayout;
    LayBot: TLayout;
    SBSalir: TSpeedButton;
    SBAcerca: TSpeedButton;
    BLimpiar: TButton;
    LayTop: TLayout;
    Layout2: TLayout;
    BInicio: TButton;
    LctSensor: TLocationSensor;
    PnlAcerca: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SBAceptar: TSpeedButton;
    VertScrollBox: TVertScrollBox;
    LayPosAct: TLayout;
    Layout7: TLayout;
    Label8: TLabel;
    Layout8: TLayout;
    Layout9: TLayout;
    LNorte: TLabel;
    Layout11: TLayout;
    LEste: TLabel;
    LayDistRec: TLayout;
    Layout12: TLayout;
    Label9: TLabel;
    Layout13: TLayout;
    LDistRec: TLabel;
    LayVel: TLayout;
    Layout14: TLayout;
    Label11: TLabel;
    Layout15: TLayout;
    LVelocidad: TLabel;
    PnlResumen: TPanel;
    Layout1: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    Layout4: TLayout;
    LPosIni: TLabel;
    Layout5: TLayout;
    Label3: TLabel;
    Layout6: TLayout;
    LPosFin: TLabel;
    Layout19: TLayout;
    Label7: TLabel;
    Layout20: TLayout;
    SBAceptarRes: TSpeedButton;
    Layout21: TLayout;
    LTmpTransc: TLabel;
    Layout22: TLayout;
    Label12: TLabel;
    Layout16: TLayout;
    Layout24: TLayout;
    LTotDistRec: TLabel;
    Layout25: TLayout;
    Label13: TLabel;
    Layout26: TLayout;
    Label10: TLabel;
    Layout27: TLayout;
    LVelProm: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Layout29: TLayout;
    Label17: TLabel;
    LAltitud: TLabel;
    Layout30: TLayout;
    Label18: TLabel;
    Layout31: TLayout;
    LVelMaxima: TLabel;
    StyleBook: TStyleBook;
    RoundRect4: TRoundRect;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Layout23: TLayout;
    Rectangle6: TRectangle;
    ImgPtosCards: TImage;
    Crcl: TCircle;
    RBAPie: TRadioButton;
    RBVehiculo: TRadioButton;
    Layout10: TLayout;
    LRumbo: TLabel;
    Label16: TLabel;
    LayBrujula: TLayout;
    Layout17: TLayout;
    procedure SBSalirClick(Sender: TObject);
    procedure BLimpiarClick(Sender: TObject);
    procedure BInicioClick(Sender: TObject);
    procedure LctSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SBAcercaClick(Sender: TObject);
    procedure SBAceptarClick(Sender: TObject);
    procedure SBAceptarResClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LctSensorHeadingChanged(Sender: TObject;
      const AHeading: THeading);
    procedure RBAPieTap(Sender: TObject; const Point: TPointF);
  private
    { Private declarations }
    procedure ValInicio;
    procedure MostrarDatos;
    procedure MostrarAcerca(Opc: boolean);
    procedure MostrarResumen(Opc: boolean);
  public
    { Public declarations }
  end;

var
  FPrinc: TFPrinc;
  Separador: char;

implementation

uses
  System.Permissions, FMX.DialogService;

{$R *.fmx}
(*{$R *.BAE2E2665F7E41AE9F0947E9D8BC3706.fmx ANDROID} *)

procedure TFPrinc.ValInicio;
begin
  BInicio.Text:='Inicio';
  BInicio.TintColor:=TAlphaColorRec.Springgreen;
  LPosIni.Text:='- - -';
  LPosFin.Text:='- - -';
  LEste.Text:='- - -';
  LNorte.Text:='- - -';
  LRumbo.Text:='- - -';
  LAltitud.Text:='- - -';
  LDistRec.Text:='0.00';
  LVelocidad.Text:='0.00';
  LTmpTransc.Text:='00:00:00';
  LTotDistRec.Text:='- - -';
  LVelProm.Text:='- - -';
  LVelMaxima.Text:='- - -';
  //se limpia el registro:
  Reg.PosInicial.X:=0;
  Reg.PosInicial.Y:=0;
  Reg.PosInicial.CG.Latitude:=0;
  Reg.PosInicial.CG.Longitude:=0;
  Reg.PosFinal.X:=0;
  Reg.PosFinal.Y:=0;
  Reg.PosFinal.CG.Latitude:=0;
  Reg.PosFinal.CG.Longitude:=0;
  Reg.PosAnterior.X:=0;
  Reg.PosAnterior.Y:=0;
  Reg.PosAnterior.CG.Latitude:=0;
  Reg.PosAnterior.CG.Longitude:=0;
  Reg.PosActual.X:=0;
  Reg.PosActual.Y:=0;
  Reg.PosActual.CG.Latitude:=0;
  Reg.PosActual.CG.Longitude:=0;
  Reg.Rumbo:='';
  Reg.DistRecorrida:=0;
  Reg.Velocidad:=0;
  Reg.VelMaxima:=0;
  Reg.Tiempo:=0;
  Reg.Altitud:=0;
  Reg.AzimutActual:=0;
  Reg.EstaIniciando:=true;
end;

procedure TFPrinc.MostrarDatos;
begin
  LEste.Text:=Round(Reg.PosActual.X).ToString;
  LNorte.Text:=Round(Reg.PosActual.Y).ToString;
  LRumbo.Text:=Reg.Rumbo;
  LAltitud.Text:=FormatFloat('#,##0.00',Reg.Altitud);
  LDistRec.Text:=FormatFloat('#,##0.00',Reg.DistRecorrida);
  LVelocidad.Text:=FormatFloat('0.00',Reg.Velocidad);
  LVelMaxima.Text:=FormatFloat('0.00',Reg.VelMaxima);
end;

procedure TFPrinc.MostrarAcerca(Opc: Boolean);
begin
  VertScrollBox.Visible:=not Opc;
  PnlAcerca.Visible:=Opc;
  LayTop.Enabled:=not Opc;
  LayBot.Enabled:=not Opc;
end;

procedure TFPrinc.MostrarResumen(Opc: Boolean);
begin
  VertScrollBox.Visible:=not Opc;
  PnlResumen.Visible:=Opc;
  LayTop.Enabled:=not Opc;
  LayBot.Enabled:=not Opc;
end;

procedure TFPrinc.RBAPieTap(Sender: TObject; const Point: TPointF);
begin
  if RBAPie.IsPressed then
  begin
    RBAPie.FontColor:=Amarillo;
    RBVehiculo.FontColor:=Blanco;
    LctSensor.ActivityType:=TLocationActivityType.Fitness;
  end
  else
  begin
    RBAPie.FontColor:=Blanco;
    RBVehiculo.FontColor:=Amarillo;
    LctSensor.ActivityType:=TLocationActivityType.Automotive;
  end;
end;

/// Eventos de la app: ///

procedure TFPrinc.FormCreate(Sender: TObject);
begin
  Separador:=FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator:='.';
  LctSensor.ActivityType:=TLocationActivityType.Fitness;
  ValInicio;
end;

procedure TFPrinc.FormDestroy(Sender: TObject);
begin
  FormatSettings.DecimalSeparator:=Separador;
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  PnlAcerca.Visible:=false;
  PnlResumen.Visible:=false;
  RBAPie.FontColor:=Amarillo;
end;

procedure TFPrinc.LctSensorHeadingChanged(Sender: TObject;
  const AHeading: THeading);
begin
  if IsNaN(AHeading.Azimuth) then
  begin
    Reg.Rumbo:='Indeterminado';
    Crcl.RotationAngle:=0;
  end
  else
  begin
    Reg.Rumbo:=FormatFloat('#0.#',AHeading.Azimuth)+'º '+
               Orientacion(AHeading.Azimuth);
    //se crea un efecto de suavizado de movimiento de la flecha:
    //RotarFlecha(Crcl,AHeading.Azimuth,Reg.AzimutActual);
    ImgPtosCards.RotationAngle:=AHeading.Azimuth*-1;
  end;
end;

procedure TFPrinc.LctSensorLocationChanged(Sender: TObject; const OldLocation,
  NewLocation: TLocationCoord2D);
var
  Distancia,IntTiempo: single;
begin
  Reg.TiempoActual:=Now;
  //se obtienen la velocidad, la altitud en msnm y el rumbo desde sensores:
  if IsNaN(LctSensor.Sensor.Speed) then Reg.Velocidad:=0
  else
  begin
    Reg.Velocidad:=LctSensor.Sensor.Speed*FactorKmh;
    if Reg.VelMaxima<Reg.Velocidad then Reg.VelMaxima:=Reg.Velocidad;
  end;
  if IsNaN(LctSensor.Sensor.Altitude) then Reg.Altitud:=0
  else Reg.Altitud:=LctSensor.Sensor.Altitude;
  //se obtienen las coordenadas (geográficas y UTM):
  CargarCoordenadas(OldLocation,Reg.PosAnterior);
  CargarCoordenadas(NewLocation,Reg.PosActual);
  if Reg.EstaIniciando then
  begin
    Reg.PosInicial:=Reg.PosActual;
    Reg.PosAnterior:=Reg.PosActual;
    Reg.EstaIniciando:=false;
  end;
  //se obtiene el intervalo de tiempo y la distancia entre los 2 puntos:
  IntTiempo:=SecondSpan(Reg.TiempoAnterior,Reg.TiempoActual);
  Distancia:=MetrosToKm(CalcularDistancia(Reg.PosAnterior.X,Reg.PosAnterior.Y,
                                          Reg.PosActual.X,Reg.PosActual.Y));
  if Reg.Velocidad>0.0 then Reg.DistRecorrida:=Reg.DistRecorrida+Distancia;
  MostrarDatos;   //se muestran los datos
  Reg.TiempoAnterior:=Reg.TiempoActual;
end;

procedure TFPrinc.BInicioClick(Sender: TObject);
begin
  ActivarGPS(LctSensor,BInicio.Text='Inicio');
  BLimpiar.Visible:=not LctSensor.Active;
  if BInicio.Text='Inicio' then
  begin
    BInicio.Text:='Fin';
    BInicio.TintColor:=TAlphaColorRec.Red;
    Reg.TiempoInicio:=Now;
    //aquí arranca el proceso:
    Reg.TiempoAnterior:=Reg.TiempoInicio;
    Reg.DistRecorrida:=0;
  end
  else
  begin
    if BInicio.Text='Resumen' then MostrarResumen(true)
    else
    begin
      BInicio.Text:='Resumen';
      BInicio.TintColor:=TAlphaColorRec.Gold;
      Reg.TiempoFin:=Now;
      Reg.Tiempo:=Reg.TiempoFin-Reg.TiempoInicio;
      //aquí se detiene el proceso:
      Reg.PosFinal:=Reg.PosActual;
      LPosIni.Text:=Round(Reg.PosInicial.X).ToString+' - '+
                    Round(Reg.PosInicial.Y).ToString;           //coord inicial
      LPosFin.Text:=Round(Reg.PosFinal.X).ToString+' - '+
                    Round(Reg.PosFinal.Y).ToString;             //coord final
      LTotDistRec.Text:=FormatFloat('0.00',Reg.DistRecorrida)+' km';  //dist recorrida
      LTmpTransc.Text:=TimeToStr(FloatToDateTime(Reg.Tiempo));  //tiempo transcurrido
      LVelProm.Text:=FormatFloat('0.00',Reg.DistRecorrida/
        HourSpan(Reg.TiempoInicio,Reg.TiempoFin))+' km/h';      //velocidad promedio
    end;
  end;
end;

procedure TFPrinc.BLimpiarClick(Sender: TObject);
begin
  ValInicio;
  ImgPtosCards.RotationAngle:=0;
end;

procedure TFPrinc.SBAcercaClick(Sender: TObject);
begin
  MostrarAcerca(true);
end;

procedure TFPrinc.SBAceptarClick(Sender: TObject);
begin
  MostrarAcerca(false);
end;

procedure TFPrinc.SBAceptarResClick(Sender: TObject);
begin
  MostrarResumen(false);
end;

procedure TFPrinc.SBSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
