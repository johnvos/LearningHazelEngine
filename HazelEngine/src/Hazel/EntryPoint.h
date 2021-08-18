#pragma once

#ifdef HZ_PLATFORM_WINDOWS

extern Hazel::Application* Hazel::CreateApplication();

int main(int argc, char** argv) {

	Hazel::Log::Init();
	HZ_CORE_WARN("Initialized Log!");
	int meh = 11;
	HZ_INFO("HI {0}!", meh);

	auto app = Hazel::CreateApplication();
	app->Run();
	delete app;
}

#endif