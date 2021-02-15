FileSystem = {}

function FileSystem.getFilesInFolder(folder)
    local command = string.format("dir \"%s\" /b", folder)
    return io.popen(command):lines()
end