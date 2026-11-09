#include <juce_core/juce_core.h>

int main()
{
    const auto musicDir = juce::File::getSpecialLocation (juce::File::userMusicDirectory);
    std::cout << juce::SystemStats::getJUCEVersion() << '\n'
              << "userMusicDirectory: " << musicDir.getFullPathName() << std::endl;
    return 0;
}
