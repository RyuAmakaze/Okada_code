int start;

// 一試行におけるそれぞれの時間(ms)を定義しています
int initial_nothing_display_ms = 7000;
int image_display_ms = 200;
int catch_answer_ms = 5000;
int trial_interval_ms = 2000;
int one_trial_ms = image_display_ms + catch_answer_ms + trial_interval_ms;


// 画像表示、被験者によるアルファベット回答で1試行です。
// 何試行目の画像表示か？
int image_displaying_num = 1;
// 何試行目の被験者の回答入力か？
int catching_answer_num = 0;
// 試行間のスクリーンが真っ黒をカウントしてます。
// 3試行目の後のスクリーン真っ暗状態なら、interval_numは3です。
int interval_num = 0;

// 表示するアルファベットの選択肢です。
String [] use_alphabets = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};

// バタワースフィルタを適用した画像には_Bを含めたファイル名にしており、バタワースフィルタではない他のフィルタ(Another Filter)にはファイル名に_Aを含めています。
// 画像をダウンロードする時に使用しました。
//String [] fileter_correspondence_table = {"A","B"};
// どのアルファベットを実験で使うかを確認する実験では、バタワースフィルタを適用したもののみを対象としました。
String [] fileter_correspondence_table = {"B"};

// 画像を保存してるpath
String image_saved_folder = "480x480";


int max_cpd = 5;
int min_cpd = 4;
// cpdの刻み幅
int cpd_stride = 1;
int cpd_num = (max_cpd - min_cpd + 1) * cpd_stride;

// loadする画像の数を計算してます。２(バタワースかそうでないフィルタを用いているか) x (選択肢となるアルファベットは何種類あるか？) x (刻み幅も考慮したcpdはいくつあるか？)
int download_img_num = fileter_correspondence_table.length * use_alphabets.length * cpd_num;

// 画像を保存する先の配列を確保してます
// +1は注視点画像です。
PImage [] imgs = new PImage [download_img_num + 1];

// 画像を保存する際に、次の３つの情報をファイル名から抽出して保存します。
// ・バタワースかそうでないフィルタを用いているか？
// ・カットオフ周波数のcpd
// ・元画像のアルファベット
String [][] img_fileName = new String[download_img_num][3];

// 何回同じ画像を表示するか？
// どのアルファベットを実験で使うかを確認する実験では、一つの画像にあたり2回の実験にしました。
int same_img_display_num = 2;

// 一回の実験で何試行するか？(何回画像が表示されるか？)
int trial_num = download_img_num * same_img_display_num;

// 実験で表示する画像の順番を指定する配列です。画像のインデックスを指定します。
int [] image_display_order = new int[trial_num];

//// 文字のサイズを予め決定して、それに対応するようにスクリーンから眼球までの距離を決定しています。
//// 文字の表示サイズ(mm)を指定してます。
//Float char_size_mm = 4.8;
//// スクリーンと眼球までの距離を計算します。
//Float screen_to_eye;
//Float tan1 = 0.01745506492;

// スクリーンから眼球までの距離を予め決定して、それに対応するように文字のサイズを決定しています。
// スクリーンと眼球までの距離(mm)を指定します。
Float screen_to_eye_mm = 580.0;
Float tan1 = 0.01745506492;
// 文字の表示サイズ(mm)を計算します。
Float char_size_mm = tan1 * screen_to_eye_mm;


// 便宜上定義しただけなので無視してください。
int index_used_onlyWhen_ImgLoad = 0;
int index_used_onlyWhen_ImgIndexMake = 0;

void setup() {
  
  // スクリーンと眼球までの距離を計算して、下の黒い部分に表示します。実験条件の確認に使ってください。
  //screen_to_eye = char_size_mm / tan1;
  //println("この文字サイズの場合、スクリーンから目の距離までは"+str(screen_to_eye/10)+"(cm)です。");
  //exit();
  
  fullScreen();
  
  // 表示条件、被験者の回答等を保存したcsvファイルです。以前作成したcsvファイルに上書きしないように、日時をファイル名にしてます。
  // 記載内容は以下の通りです。
  // 最初のスクリーンが真っ暗な時間、画像表示時間、キーボードによる被験者の回答を待つ時間（一定です）、次の画像が表示されるまでの時間
  // 何度目の画像表示、適用してるフィルター、カットオフ周波数、元画像のアルファベット、被験者が回答したアルファベット
  file = createWriter(month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second());
  
  // 「最初のスクリーンが真っ暗な時間、画像表示時間、キーボードによる被験者の回答を待つ時間（一定です）、次の画像が表示されるまでの時間」をcsvファイルに入力してます。
  file.print("first dark screen ms, "+str(initial_nothing_display_ms));
  file.print(", image display ms, "+str(image_display_ms));
  file.print(", wait for subject respond, "+str(catch_answer_ms));
  file.println(", ms for next image display, "+str(trial_interval_ms));
  file.println(""); // 改行
  file.println("");
  
  // csvファイルだけを見て理解できるように「何度目の画像表示、適用してるフィルター、カットオフ周波数、元画像のアルファベット、被験者が回答したアルファベット」という項目名を入力しました。
  file.println("trial, Filter Name, Cutoff CPD, display Alphabet, subject answer");
  
  //// image_display_orderがきちんとシャッフルできてるか等を確認するために作ったcsvファイルです。
  //file_test = createWriter(month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"_test");

  
  // 画像のダウンロードと同時にファイル名も保存してます。
  for(int alphabet_index = 0; alphabet_index < use_alphabets.length ; alphabet_index++){
    for(int cpd = min_cpd; cpd <= max_cpd ; cpd += cpd_stride){
      for(int filter = 0; filter < fileter_correspondence_table.length ; filter++){
        // 画像のダウンロード部分です。
        imgs[index_used_onlyWhen_ImgLoad] = loadImage(image_saved_folder+'/'+use_alphabets[alphabet_index]+"_"+str(cpd)+"cpd_"+fileter_correspondence_table[filter]+"filter.png");
        // 画像をグレースケールに変更してます。
        imgs[index_used_onlyWhen_ImgLoad].filter(GRAY);
        // 画像のサイズを変更してます。
        // 岡田のパソコンでは、1mmを表現する際に、5pixel使用していたため、char_size_mmに５を掛けてます。２つ目の引数の０は、１つ目の引数と同じことを意味してます。
        imgs[index_used_onlyWhen_ImgLoad].resize( int(char_size_mm*5), 0 );
        
        // ファイル名の保存部分です。
        img_fileName[index_used_onlyWhen_ImgLoad][0] = use_alphabets[alphabet_index];
        img_fileName[index_used_onlyWhen_ImgLoad][1] = str(cpd);
        
        // fileter_correspondence_tableに対応させます。
        if (filter == 0){
          img_fileName[index_used_onlyWhen_ImgLoad][2] = "Butterworth Filter";
        }
        if (filter == 1){
          img_fileName[index_used_onlyWhen_ImgLoad][2] = "Another Filter";
        }
        
        index_used_onlyWhen_ImgLoad++;
      }
    }
  }
  
  // imgs配列の最後に注視点画像をloadしました。
  imgs[download_img_num] = loadImage("fixation_point.png");
  
  // 画像を表示する順番を決めます。シャッフルするためにまずは配列を作ってます。
  for(int trial=0 ; trial < same_img_display_num ; trial++){
    for(int i = 0; i < download_img_num ; i++){
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
  
  // きちんと表示する画像のインデックスがシャッフルされているかをcsvファイルに書き込んで確認しました。
  //for ( int test = 0; test < trial_num ; test++ ) {
  //  file_test.println(str(test)+", "+str(image_display_order[test]));
  // }
  //file_test.flush();
  //file_test.close();
  //exit();
  
  start = millis();
  //println("start : " + start);
}

void draw() {
  background(0);
  display();
}

// csvファイルを作成する際に必要な宣言です。
PrintWriter file;
//PrintWriter file_test;

String subject_answer = "";

// 表示する画像のインデックスが入力されます。
int ind;

int Eliminate_lag = 0;

void display(){
  
  //if (Eliminate_lag == 0){
  //  Eliminate_lag++;
  //  start = millis();
  //}
  
  //println(millis());
  
  // 最初に注視点を表示します。
  if (( 0 <= millis() - start ) 
  && ( millis() - start < initial_nothing_display_ms )){
    image(imgs[download_img_num], width/2-imgs[download_img_num].width/2, height/2-imgs[download_img_num].height/2);
    
    //println("fixation point");
  }
    
  // 画像を表示させる部分です。
  if (( initial_nothing_display_ms +one_trial_ms*(image_displaying_num-1) <= millis() - start ) 
  && ( millis() - start < initial_nothing_display_ms +one_trial_ms*(image_displaying_num-1) +image_display_ms )) {
    // 表示する画像のインデックスを調べてます。
    ind = image_display_order[image_displaying_num-1];
    // 画像を中央に表示させてます。
    image(imgs[ind], width/2-imgs[ind].width/2, height/2-imgs[ind].height/2);
    
    catching_answer_num = image_displaying_num;
    
    // 動作確認用のプログラムです。
    //println("catching_answer_num: "+catching_answer_num);
    
    //println("imgs display");
  }
    
  // 被験者からの入力を待つ部分です。
  if (catching_answer_num-1 >= 0){
    
    if (( start+initial_nothing_display_ms +one_trial_ms*(catching_answer_num-1) +image_display_ms <= millis() ) 
    && ( millis() < start+initial_nothing_display_ms +one_trial_ms*(catching_answer_num-1) +image_display_ms+catch_answer_ms )) {
      // 被験者から何も入力がない間は、画面の中央に「catching answer」と表示してます。
      if (subject_answer == ""){
        fill(255);
        text("catching answer", width/2, height/2);
      }
      
      // 被験者からのアルファベット入力を大文字にして、subject_answerにて保持します。
      // 再度入力すると、subject_answerに保持されるアルファベットも変更します。最後に入力されたアルファベットを被験者の回答と捉えてます。
      catchKey_display();
      
      // 被験者の回答を表示します。
      fill(255);
      text(subject_answer, width/2, height/2);
      
      interval_num = catching_answer_num;
      
      // 動作確認用のプログラムです。
      //println("interval_num: "+interval_num);
      
      //println("answer");
    }
    
  }
    
  // 試行(画像表示、被験者の回答)と試行の間のスクリーンが注視点が表示されたな状態です。
  if (interval_num-1 >= 0){
  
    if (( start+initial_nothing_display_ms +one_trial_ms*(interval_num-1) +image_display_ms+catch_answer_ms <= millis() ) 
    && ( millis() < start+initial_nothing_display_ms +one_trial_ms*(interval_num-1) +image_display_ms+catch_answer_ms+trial_interval_ms )) {
      // 被験者の回答をcsvファイルに記録します。
      if (image_displaying_num == interval_num){
        // 「何度目の画像表示、適用してるフィルター、カットオフ周波数、元画像のアルファベット、被験者が回答したアルファベット」をcsvファイルに入力します。
        file.print( str(image_displaying_num)+", " );
        file.print( img_fileName[ind][2]+", " );
        file.print( img_fileName[ind][1]+", " );
        file.print( img_fileName[ind][0]+", " );
        file.println( subject_answer );
        
        // 最終の試行かどうかを判断してます。
        if ( trial_num == catching_answer_num){
          file.flush();
          file.close();
          exit();
        }
      }
      
      // 「interval」と表示させることで動作してるかを確認してます。
      //fill(255);
      //text("interval", width/2, height/2);
      
      image(imgs[download_img_num], width/2-imgs[download_img_num].width/2, height/2-imgs[download_img_num].height/2);
      
      image_displaying_num = interval_num+1;
      
      // 被験者の回答を初期化してます。
      subject_answer = "";
      
      // 動作確認用のプログラムです。
      //println("image_displaying_num: "+image_displaying_num);
      
      //println("interval");
    }
    
  }
  
}


// 被験者からのアルファベット入力を大文字にして、subject_answerにて保持します。
void catchKey_display(){
  if( keyPressed == true ){
    fill(0);
    // 小文字入力を大文字に変換してます。
    subject_answer = str(key).toUpperCase();
  }
}
