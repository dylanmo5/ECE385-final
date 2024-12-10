#include <cmath>
#include <print>

int main() {
  for (int note_number = 48; note_number <= 83; ++note_number) {
    double frequency = 440 * std::pow(2.0, static_cast<double>(note_number - 69) / 12); // in mHz, millihertz
    std::println("{:06x}", static_cast<int>((frequency / 48000) * std::pow(2, 24)));
  }
  // std::println("Test: ");
  // std::println("{:06x}", static_cast<int>((6000. / 48000) * std::pow(2, 24)));
  // std::println("{:06x}", static_cast<int>((12000. / 48000) * std::pow(2, 24)));
  // std::println("{:06x}", static_cast<int>((24000. / 48000) * std::pow(2, 24)));
  // std::println("{:06x}", static_cast<int>((48000. / 48000) * std::pow(2, 24)));
}
