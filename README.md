# GazelCompressionTool
Uses precomp and zpaq to more optimally compress files.

https://github.com/schnaader/precomp-cpp
https://github.com/zpaq/zpaq

It's jank, I know. Here's how to use it

1. Put GazelCompressionTool.exe (or all 3 source files) in directory with file you want to compress.
2. Run gct.bat, follow on screen prompts, and wait.

Command Line Args (case-sensitive):
1st (& 2nd) arg:

	--cleanup (will delete the 3 source files after running)
	-C fileName.extension (will compress the specified file to a .zpaq file [arbitrary extension])
	-D fileName.zpaq (will decompress the specified file back to what it originally was)


3rd arg (Only use with -C or -D and fileName args):

	--cleanup (will additionally delete the file being operated on, the pre-compressed if compressing or pre-decompressed if decompressing)
