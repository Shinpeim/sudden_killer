# -*- coding: utf-8 -*-
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

describe SK::Killer do
  before do
    @filter = SK::Killer.new(File.join(SK.root, 'okura-dic'))
  end

  context '「動詞 + て(助詞)」が含まれるとき' do
    it "一番後ろの「動詞 + て」でマッチして「突然の死」を返す" do
      @filter.kill("それから少し間を置いて、私は部屋に帰った").should ==
        "それから少し間を置いて" + SK::TOTSUZENSHI_AA
    end
  end

  context '「名詞 + だ(助詞) + と(助詞)」が含まれるとき' do
    it "一番後ろの「名詞 + だ + と」でマッチして「突然の死」を返す" do
      @filter.kill("ご飯を食べるときに、あんまり周りが静かだと緊張する").should ==
        "ご飯を食べるときに、あんまり周りが静かだと" + SK::TOTSUZENSHI_AA
    end
  end

  context '何も含まれないとき' do
    it "nilを返す" do
      @filter.kill("XXXXXXXXXXXXXXX").should == nil
    end
  end
end
