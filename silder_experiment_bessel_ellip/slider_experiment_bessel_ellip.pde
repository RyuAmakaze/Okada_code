import controlP5.*;

// 表示するアルファベットの選択肢です。
String [] use_alphabets = {"B","D","F","M","R"};

// 画像をダウンロードする時に使用しました。
String [] fileter_correspondence_table = {"Ellip","Bessel"};

// 画像を保存してるpath
String image_saved_folder = "Passed_480x480";

// 1.5とかですると、計算の際に誤差が出てエラーが出るため、整数にしました。79の場合は7.9のように、0.1倍して考えてください。
int max_cpd = 139;
int min_cpd = 20;
// cpdのトータルの数です。
int cpd_num = max_cpd - min_cpd + 1 ;

int alphabet_x_filter = fileter_correspondence_table.length * use_alphabets.length;

// 画像を保存する先の配列を確保してます
PImage [][] which_images = new PImage [alphabet_x_filter][cpd_num];

// 画像を保存する際に、次の2つの情報をファイル名から抽出して保存します。csvファイルに保存する際に使います。
// ・元画像のアルファベット
// ・ベッセルフィルタか？FIRフィルタか？
String [][] which_alphabet_filter = new String[alphabet_x_filter][2];

// 何回同じ画像を表示するか？
int repeat_num = 20;

// トータルで何回試行するか？
int trial_num = alphabet_x_filter * repeat_num;

// 実験で表示する画像の順番を指定する配列です。画像のインデックスを指定します。
int [] image_display_order = new int[trial_num];

// スライダーを作成する際に必要な宣言です。
ControlP5 cp5;
int cpd_now;
// csvファイルを作成する際に必要な宣言です。
PrintWriter file;

// スクリーンから眼球までの距離を予め決定して、それに対応するように文字のサイズを決定しています。
// スクリーンと眼球までの距離(mm)を指定します。
Float screen_to_eye_mm = 450.0;
Float tan1 = 0.01745506492;
// 文字の表示サイズ(mm)を計算します。
Float char_size_mm = tan1 * screen_to_eye_mm;


// 便宜上定義しただけなので無視してください。
int index_used_onlyWhen_ImgLoad = 0;
int index_used_onlyWhen_ImgIndexMake = 0;

void setup() {
  fullScreen();
  
  //print("trial num is ",trial_num);
  
  // ファイル名を決めてます。
  file = createWriter(month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second());
  
  // csvファイルだけを見て理解できるように「何度目の画像表示、元画像のアルファベット、適用してるフィルター、被験者が回答したカットオフ周波数」という項目名を入力しました。
  file.println("trial, Display Alphabet, Filter Name, subject Answer CPD");
  file.flush();
  
  // 画像のダウンロードと同時にファイル名も保存してます。ファイル名はcsvファイルを作成する際に使います。
  for(int alphabet_index = 0; alphabet_index < use_alphabets.length ; alphabet_index++){
    for(int filter = 0; filter < fileter_correspondence_table.length ; filter++){
      for(int cpd = min_cpd; cpd <= max_cpd ; cpd ++){
        // 画像のダウンロード部分です。
        which_images[index_used_onlyWhen_ImgLoad][ cpd-min_cpd ] = loadImage(image_saved_folder+'/'+use_alphabets[alphabet_index]+"_"+str(cpd/10)+"cycle_"+fileter_correspondence_table[filter]+"filter.png");
        // 画像をグレースケールに変更してます。
        which_images[index_used_onlyWhen_ImgLoad][ cpd-min_cpd ].filter(GRAY);
        // 画像のサイズを変更してます。
        char_size_mm = tan( (cpd/10)*10 * ( PI / 180 )/cpd ) * screen_to_eye_mm;
        //char_size_mm = 100.0;
        // 岡田のパソコンでは、1mmを表現する際に、5pixel使用していたため、char_size_mmに５を掛けてます。２つ目の引数の０は、１つ目の引数と同じことを意味してます。
        which_images[index_used_onlyWhen_ImgLoad][ cpd-min_cpd ].resize( int(char_size_mm*5), 0 );
        
      }
    // どのアルファベットかをwhich_alphabet_filterに保存します。
    which_alphabet_filter[index_used_onlyWhen_ImgLoad][0] = use_alphabets[alphabet_index];
    
    // どのフィルタを用いたかをwhich_alphabet_filterに保存します。
    // fileter_correspondence_tableに対応させます。
    if (filter == 0){
      which_alphabet_filter[index_used_onlyWhen_ImgLoad][1] = "Ellip";
    }
    if (filter == 1){
      which_alphabet_filter[index_used_onlyWhen_ImgLoad][1] = "Bessel";
    }
    
    index_used_onlyWhen_ImgLoad++;
      
    }
  }
  
  
  // 画像を表示する順番を決めます。シャッフルするためにまずは配列を作ってます。
  for(int j=0 ; j < repeat_num ; j++){
    for(int i = 0; i < alphabet_x_filter ; i++){
      image_display_order[index_used_onlyWhen_ImgIndexMake] = i;
      index_used_onlyWhen_ImgIndexMake++;
    }
  }
  // 画像を表示する順番を決めます。シャッフルしてます。
  for ( int j = 0; j < trial_num ; j++ ) {
     // 0～(配列same_img_display_numの個数-1)の乱数を発生
     int rnd = (int)( Math.random() * (double)trial_num );
     // same_img_display_num[ j ]とsame_img_display_num[ rnd ]を入れ替える
     int w = image_display_order[ j ];
     image_display_order[ j ] = image_display_order[ rnd ];
     image_display_order[ rnd ] = w;
   }
  
  // スライダーを設定しています。
  cp5 = new ControlP5(this);
  cp5.addSlider("cpd_now")
    .setRange(min_cpd+1, max_cpd-1)
    .setValue( min_cpd )
    //.setValue( max_cpd )
    .setPosition(width/2-300, height-50)
    .setSize(600, 20);
    
  println(millis());
}

void draw() {
  // 0は黒です。
  background(0);
  display();
}

// 現在、何試行目かを保存してます。
int trial_now = 0;
// 表示する画像のインデックスを代入します。
int using_index = 0;
// 表示する画像自体を代入します。
PImage image_display_now;
// マウスを使ってない時を0、使った時を1とします。
int subject_use_mouse = 0;

void display(){
  // 何番目にロードした画像で試行をするかを判断してます。
  using_index = image_display_order[trial_now];
  
  // 表示する画像を代入してます。
  image_display_now = which_images[using_index][ cpd_now-min_cpd ];
  
  // 画像を表示させてます。
  image(image_display_now, width/2-image_display_now.width/2, height/2-image_display_now.height/2);
  
  // 特定のキーボード入力により、次の試行に移行させる自作関数です。
  key_next();
  
  // 被験者がマウスを動かしたかを確認する自作関数です。
  mouse_move_check();
  
  // 最終試行かどうかを確認する自作関数です。
  judge_end();
}

void key_next() {
  if ( ( keyPressed == true ) && ( key == ' ' )  ){
    if (subject_use_mouse==1){
      // 試行が終了するごとに、結果をcsvファイルに保存してます。
      write_csv();
      
      cp5.addSlider("cpd_now")
        .setRange(min_cpd+1, max_cpd-1)
        .setValue( min_cpd )
        //.setValue( max_cpd )
        .setPosition(width/2-300, height-50)
        .setSize(600, 20);
        
      trial_now ++;
      subject_use_mouse = 0;
    }
  }
}

void write_csv() {
  // 「何度目の画像表示か？、元画像のアルファベット、適用してるフィルター、被験者が回答した周波数」項目名をcsvファイルに入力しました。
  file.print( str(trial_now)+", " );
  file.print( which_alphabet_filter[using_index][0]+", " );
  file.print( which_alphabet_filter[using_index][1]+", " );
  file.println( cpd_now );
  // その都度、入力を保存します。
  file.flush();
  //file.close();
}

void mouse_move_check() {
  if (mousePressed == true){
    //print("subject mouse use!!");
    subject_use_mouse = 1;
  }
}

void judge_end() {
  if (trial_now == trial_num){
    //file.flush();
    // 最後にfileを閉じます。
    file.close();
    println(millis());
    exit();
  }
}
