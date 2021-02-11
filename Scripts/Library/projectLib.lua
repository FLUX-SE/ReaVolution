--Script Name : projectLib.lua
--Author : Jean Loup Pecquais
--Description : Function related to project manipulation
--v1.0.0

function countProjects()

	local numberOfProject = 0

	while reaper.EnumProjects( numberOfProject ) ~= nil do
		numberOfProject = numberOfProject + 1
	end

	return numberOfProject

end

function getProjectIndex( proj )
	local numberOfProject = countProjects()

	for i = 0, numberOfProject do
		if proj == reaper.EnumProjects( i ) then
			return i
		end
	end

end