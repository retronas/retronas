You can run make in the dist dir to get a list of available procedures.

If you get errors like this then it's likely a version mismatch between the iso you are working from and the one that you used previously, so delete the tmp directories:

2022-03-13 04:15:06 ERROR reprepro: updating package lists exited with code 255
2022-03-13 04:15:06 ERROR Last 5 lines of standard error:
2022-03-13 04:15:06 ERROR reprepro: updating package lists: of the databases belonging to those removed parts.
2022-03-13 04:15:06 ERROR reprepro: updating package lists: (Another reason to get this error is using conf/ and db/ directories
2022-03-13 04:15:06 ERROR reprepro: updating package lists:  belonging to different reprepro repositories).
2022-03-13 04:15:06 ERROR reprepro: updating package lists: To ignore use --ignore=undefinedtarget.
2022-03-13 04:15:06 ERROR reprepro: updating package lists: There have been errors!
2022-03-13 04:15:06 ERROR reprepro failed with exit code: 255

Explanation of the simple-cdd conf:

https://gist.github.com/w33tmaricich/5a49ce5af5e8655258fe1ec939785fc9

The preseed file was taken from some boilerplate that is meant to remove all the questions, so we can remove whatever we want from it easily.
