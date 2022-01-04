# iris Refatorada

O App Iris tem como função controlar, monitorar e conectar a IRIS. Esta é a versao refatorada.

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
### GateIRIS -> [GateIRIS](https://github.com/I-grow/Gateway_IRIS).
### Desenvolvedor -> [Daniel Arndt](https://github.com/Chimeric-arch).
-------------------------------------------------------------------------------
### IRIS Station  -> [IRIS Station](https://github.com/I-grow/Station_IRIS).
### Desenvolvedor -> [Daniel Arndt](https://github.com/Chimeric-arch).
-------------------------------------------------------------------------------
### IRIS App -> [IRIS App](https://github.com/SI-ART/IrisAPP_Refactored).
### Desenvolvedor -> [João Vitor](https://github.com/jajao1).
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

##  Modificações

- Cores primarias trocadas

- Ultização do MobX

- Login refatorado

- Services e models Refatorados

- Aplicativo Modular

- Separação de Widget e API

- Corrigido o bug do bluetooth na estação
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

## BLUETOOTH LOW ENERGY
A configuração inicial do *AppIris* é feita através do protocolo *Bluetooth Low Energy* (BLE), um protocolo de comunicação sem fio, caracterizado pelo seu baixo consumo de energia. Nesta etapa, o *AppIris* enviara as seguinte informações para ser conectado: 

- *SSID* da rede wifi;

- Senha da rede wifi;

- ID da conta do usuário;

- ID do *gateway* registrado na conta.

Sendo o *GID*(Gateway ID) e *UID*(USER ID), passador sem que o usuario perceba.

As informações acima são compartilhadas a partir da seguinte conexão: O *GateIRIS* cria um servidor bluetooth para possibilitar a comunicação com o cliente aplicativo *IRIS* (*clientAPP*).

As ferramentas usadas para executar esse processo pertece aos seguintes desenvolvedores.

## RxAndroidBle
### RxAndroidBle -> [RxAndroidBle](https://github.com/Polidea/RxAndroidBle).
### Desenvolvedor -> [Polidea](https://github.com/Polidea).

-------------------------------------------------------------------------------

## flutter_reactive_ble
### flutter_reactive_ble -> [flutter_reactive_ble](https://github.com/PhilipsHue/flutter_reactive_ble).
### Desenvolvedor -> [Philips Hue](https://github.com/PhilipsHue).

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


## Plugins e programas
### Android Studio -> [Android Studio](https://redirector.gvt1.com/edgedl/android/studio/install/2020.3.1.24/android-studio-2020.3.1.24-windows.exe).
### Chocolatey -> [Chocolatey](https://chocolatey.org/install).
### Chocolatey -> [Chocolatey JDK](https://community.chocolatey.org/packages/jdk8).
### Chocolatey -> [Chocolatey Flutter](https://community.chocolatey.org/packages/flutter).


## Comandos
|  CMD  | DESCRIÇÃO                                                           |
|:-----:|---------------------------------------------------------------------|
|  *flutter build apk*  | *cria um apk realease*                              |
|  *flutter pub get*    | *usado para a IDE reconhecer as bibliotecas*        |
|  *flutter clean*      | *apaga os arquivos lixos*                           |
> Tabela 1.


## Observações 

>Ao ultizado o MobX o aplicativo tem uma melhora no cosumo de RAM, e eviatndo memorys leaks e stacks overflows
> 
> Ultilização do Modular, proporcionando uma melhor navegação entre telas

## A fazer

>Refatoração total do widget de dados e sensores
>
> Bottom nav bar
> 
> Sqlite
> 
> Teste Unitario
>  
> Http Requests




