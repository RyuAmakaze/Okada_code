# Okada_code

## Imageフォルダ
画像ファイルが複数枚格納されている．

## PowerSpectrum.ipynb
Imagesフォルダにあるアルファベット画像のパワースペクトルと位相をクロスさせる．
MIX(A,B)と指定すれば，  
位相はAスペクトルはA，  
位相はAスペクトルはB，  
位相はBスペクトルはB，  
位相はBスペクトルはA，  
を表示する．

## sketch_01phaseANDspec.pde
Processing(https://processing.org/)を用いる．  
  
### pre_01phase_specフォルダ
pre_01phase_specフォルダ内の1.5GBの画像を入れて動かす． 
![image](https://user-images.githubusercontent.com/43159778/132652381-a5f85028-60ab-41fc-abda-865995b71a4f.png)
フォルダ名0,5,10,15,は位相をどれだけ行ったか．[0=0, 128 = πに相当．]
ファイル名53_1.pngはカットオフ周波数_(1=バタワースフィルタ，3=位相変調のあるフィルタ)

### controlP5のインストール手順．  
#### ・ツールを追加する．  
![image](https://user-images.githubusercontent.com/43159778/132651608-55171b5f-02de-4d83-96dd-bebd0db45b3c.png)

#### ・ライブラリを選択　→　ControlP5 で検索　→　Install  
![image](https://user-images.githubusercontent.com/43159778/132651693-86be2e28-86a9-4035-a70a-91db0f1366f7.png)
