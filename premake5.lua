workspace "HazelEngine"
	architecture "x64"
	startproject "Sandbox"
	
	configurations {
		"Debug", 
		"Release",
		"Dist"
	}
	
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder {solution directory}
IncludeDir = {}
IncludeDir["GLFW"] = "HazelEngine/vendor/GLFW/include"
IncludeDir["Glad"] = "HazelEngine/vendor/GLAD/include"
IncludeDir["ImGui"] = "HazelEngine/vendor/imgui"
IncludeDir["glm"] = "HazelEngine/vendor/glm"

include "HazelEngine/vendor/GLFW"
include "HazelEngine/vendor/Glad"
include "HazelEngine/vendor/imgui"

project "HazelEngine"
	location "HazelEngine"
	kind "SharedLib"
	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	
	pchheader "hzpch.h"
	pchsource "HazelEngine/src/hzpch.cpp"

	files{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"
	}

	links{
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib"
	}

	filter "system:windows"
		cppdialect "C++17"
		systemversion "latest"

		defines{
			"HZ_PLATFORM_WINDOWS",
			"HZ_BUILD_DLL",
			"GLFW_INCLUDE_NONE",
			"IMGL3W_IMPL"
		}

		postbuildcommands{
			("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
		}

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug" 
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		symbols "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		symbols "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	
	files{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs{
		"HazelEngine/vendor/spdlog/include",
		"HazelEngine/src",
		"%{IncludeDir.glm}"
	}

	links {
		"HazelEngine"
	}

	filter "system:windows"
		cppdialect "C++17"
		systemversion "latest"

		defines{
			"HZ_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		symbols "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		symbols "On"
