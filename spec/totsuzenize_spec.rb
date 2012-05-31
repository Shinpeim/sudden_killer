# -*- coding: utf-8 -*-
require File.join(File.expand_path(File.dirname(__FILE__)) , 'spec_helper')

TOTSUZENSHI_AA = "
＿人人人人人＿
＞ 突然の死 ＜
￣ＹＹＹＹＹ￣"

describe T::Filter do
  before do
    @filter = T::Filter.new(File.join(T.root, 'okura-dic'))
  end

  context '「名詞 + 助詞」が含まれるとき' do
    it "一番後ろの「名詞 + 助詞」でマッチして「突然の死」を返す" do
      @filter.totsuzenize("あの夏で待ってるっていうアニメを好む人間は良いやつだと思う").should ==
        "あの夏で待ってるっていうアニメを好む人間は" + TOTSUZENSHI_AA
    end
  end
end
