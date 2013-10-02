class SystemSounds
  class << self

    #TODO check if these methods are really needed to play system sounds
    BASE_AUDIO_PATH = "/System/Library/Sounds/"
    @@system_sounds = {}

    def play_system_sound(file_name)
      path = "#{BASE_AUDIO_PATH}#{file_name}"
      sound_id = find_or_create_sound_id(path)
      AudioServicesPlaySystemSound(sound_id[0])
    end

    def find_or_create_sound_id(file_name)
      unless sound_id = @@system_sounds[file_name]
        sound_id = Pointer.new('I')
        @@system_sounds[file_name] = sound_id
        AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath(file_name), sound_id)
      end

      sound_id
    end

  end
end