# -*- coding: utf-8 -*-
require 'sudden_killer/filter'

module SuddenKiller

  TOTSUZENSHI_AA = "\n＿人人人人人＿\n＞ 突然の死 ＜\n￣ＹＹＹＹＹ￣"

  class << self
    def root
      File.join(File.expand_path(File.dirname(__FILE__)), '..')
    end
  end
end

#alias for SuddenKiller
SK = SuddenKiller
