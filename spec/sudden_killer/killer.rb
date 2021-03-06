# -*- coding: utf-8 -*-
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

describe SK::Killer do
  before do
    @filter = SK::Killer.new(File.join(SK.root, 'okura-dic'))
  end

  context '「名詞 + だ (助動詞) + けど(助詞)」が含まれるとき' do
    it "一番後ろでマッチして「突然の死」を返す" do
      @filter.kill("私美少女だけどsudden killer氏かっこいいと思う").should ==
        "私美少女だけど" + SK::TOTSUZENSHI_AA
    end
  end

  context '「動詞 + た (助動詞) + けど(助詞)」が含まれるとき' do
    it "一番後ろの「動詞 + たけど」でマッチして「突然の死」を返す" do
      @filter.kill("昨日は途中で帰ったけど、明日は全参加するわ").should ==
        "昨日は途中で帰ったけど" + SK::TOTSUZENSHI_AA
    end
  end

  context '「動詞 + けど(助詞)」が含まれるとき' do
    it "一番後ろの「動詞 + けど」でマッチして「突然の死」を返す" do
      @filter.kill("今日は途中で帰るけど、明日は全参加するわ").should ==
        "今日は途中で帰るけど" + SK::TOTSUZENSHI_AA
    end
  end

  context '「名詞 + で(助詞)」が含まれるとき' do
    it "一番後ろの「名詞 + で」でマッチして「突然の死」を返す" do
      @filter.kill("スターバックスもあるし、代々木で待つわ").should ==
        "スターバックスもあるし、代々木で" + SK::TOTSUZENSHI_AA
    end
  end

  context '「動詞 + と(助詞)」が含まれるとき' do
    it "一番後ろの「動詞 + と」でマッチして「突然の死」を返す" do
      @filter.kill("おばあさんが川で洗濯をしていると、突然上流から大きな桃が").should ==
        "おばあさんが川で洗濯をしていると" + SK::TOTSUZENSHI_AA
    end
  end

  context '「名詞 + だ(助詞) + と(助詞)」が含まれるとき' do
    it "一番後ろの「名詞 + だ + と」でマッチして「突然の死」を返す" do
      @filter.kill("ご飯を食べるときに、あんまり周りが静かだと緊張する").should ==
        "ご飯を食べるときに、あんまり周りが静かだと" + SK::TOTSUZENSHI_AA
    end
  end

  context '「名詞 + に(助詞)」が含まれるとき' do
    it "一番後ろの「名詞 + に」でマッチして「突然の死」を返す" do
      @filter.kill("9mさん謹製のリマインダ氏にゴミ出しアラート機能ほしい").should ==
        "9mさん謹製のリマインダ氏に" + SK::TOTSUZENSHI_AA
    end
  end

  context '何も含まれないとき' do
    it "nilを返す" do
      @filter.kill("XXXXXXXXXXXXXXX").should == nil
    end
  end
end
