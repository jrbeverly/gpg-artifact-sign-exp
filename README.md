# GPG Artifact Sign Experiment

Minor experiment with a shell script for signing artifacts that would be generated from a build process.

## Notes

- Build tooling can support multiple checksum algorithms (sha256/sha1/md5/sha512/etc)
- Docker Container Trust (DCT) didn't fit with the usecase/portability desired
- GPG is the standard way for doing this (can this be packaged into something more portable?)
- Design should aim to be agnostic of GitHub Releases or any other platform
- Build tooling likely doesn't need to understand the concept of "signing" (or should it?)
- If build tools understand signing, does that mean there need to be 'Developer Keys'?
    - Is this really just as just a matter of familiarity?
- The CI/Build process is responsible for signing files to assert that "it" was responsible for the build (e.g. not just dev artifacts published to S3)

