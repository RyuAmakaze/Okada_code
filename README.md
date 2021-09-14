# Okada_code

## 1.Imageフォルダ
A~Zまでの26文字の画像ファイルが複数枚格納されている．

## 2.PowerSpectrum.ipynb
Imagesフォルダにあるアルファベット画像のパワースペクトルと位相をクロスさせる．
MIX(A,B)と指定すれば，  
位相はAスペクトルはA，  
位相はAスペクトルはB，  
位相はBスペクトルはB，  
位相はBスペクトルはA，  
を表示する．

## 3.sketch_01phaseANDspec.pde
Processing(https://processing.org/)  
pre_01phase_specフォルダを同階層に置いて，動作する．
  
### 3.1 pre_01phase_specフォルダ
pre_01phase_specフォルダ内の1.5GBの画像を入れて動かす．   
![image](https://user-images.githubusercontent.com/43159778/132652381-a5f85028-60ab-41fc-abda-865995b71a4f.png)  
フォルダ名0,5,10,15,は位相をどれだけ行ったか．[0=0, 128 = πに相当．]
ファイル名53_1.pngはカットオフ周波数_(1=バタワースフィルタ，3=位相変調のあるフィルタ)

### 3.2 controlP5のインストール手順．  
#### ・ツールを追加する．  
![image](https://user-images.githubusercontent.com/43159778/132651608-55171b5f-02de-4d83-96dd-bebd0db45b3c.png)

#### ・ライブラリを選択　→　ControlP5 で検索　→　Install  
![image](https://user-images.githubusercontent.com/43159778/132651693-86be2e28-86a9-4035-a70a-91db0f1366f7.png)

## 4.Character_onBlack___Passed_butter_another.ipynb
このファイルは２つのプログラムを含んでます。
黒の地に白のアルファベットを描く画像を取得するプログラムと、その画像に対してバタワースフィルタとその他のフィルタを適用した結果を取得するプログラムです。

まずは、黒の地に白のアルファベットを描く画像を取得するプログラムについてです。
new_dir_path　のフォルダの下に、黒の地に白のアルファベットを描く画像を保存してます。
正方形の画像を作成しています。　square　という変数で一辺のpixelを表現しています。
変更してほしい部分：new_dir_path

次に、バタワースフィルタとその他のフィルタを適用した結果を取得するプログラムについてです。
Passed_save_path　というフォルダに２つのフィルタを適用した結果を保存しています。
min_cycle　と　max_cycle　は、画像の範囲に白黒のしましまを何個表現できるかの下限と上限です。
ファイル名のAfilterはAnother LowpassFilterの略です。Bfilterはバタワース（Butterworth）フィルタの略です。
変更してほしい部分：Passed_save_path

## 3.experiment_which_alphabet_use
実験に使うアルファベットを決定するためのプログラムです。

### 3.1 experiment_which_alphabet_use.pde
画像表示、被験者によるアルファベット回答を１試行としてします。

####　実験の流れ
注視点表示(最初のみ) =><br>
画像表示　=> 被験者による回答　=> 注視点表示 (この行のサイクルを繰り返します)

画像表示時間( image_display_ms )は、先行研究から200msにしています。
最初の注視点表示時間( initial_nothing_display_ms ), 被験者による回答時間( catch_answer_ms ), 注視点表示時間( catch_answer_ms )は先行研究に依ってないです。

#### して欲しいこと
同じ階層に 480x480 というフォルダを作成して、そこにバタワースフィルタとその他のフィルタを適用した画像を保存してください。Character_onBlack___Passed_butter_another.ipynbで作成できます。
実験する前に、スクリーンと目との距離を測って、　screen_to_eye_mm　という変数に代入して欲しいです。
min_cpdでも全て読める場合は、　min_cpd　（と　max_cpd　）を小さくしてください。
ただ、Character_onBlack___Passed_butter_another.ipynb　の　min_cycle　〜　max_cycle　から外れる範囲の　min_cpd 〜　max_cpd　を指定するとエラーが出ます。
この場合は、min_cpd 〜　max_cpd　がmin_cycle　〜　max_cycleに含まれるように、Character_onBlack___Passed_butter_another.ipynb　の　min_cycle　, max_cycle　を変更、実行してください。

#### 補足説明
cpdの刻み幅（cpd_stride）は１としています。
バタワースフィルタ適用画像のみが表示されます。
同じ階層に、日時をファイル名としたcsvファイルができて、そこに実験結果が保存されます。最後にcsvファイルに保存するため、最後まで実験していただかないと実験結果が保存できない仕様になっています。
