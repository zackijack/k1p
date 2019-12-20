/*
Copyright © 2019 Zackky Muhammad <m.zackky@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/zackijack/k1p/internal/version"
)

const versionDesc = `
Show the version for k1p.
This will print a representation the version of k1p.
The output will look something like this:

Version: v1.0.0
Git Commit: "ff52399e51bb880526e9cd0ed8386f6433b74da1"
Git Tree State: "clean"

- Version is the semantic version of the release.
- Git Commit is the SHA for the commit that this version was built from.
- Git Tree State is "clean" if there are no local code changes when this binary was
  built, and "dirty" if the binary was built from locally modified code.
`

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the k1p version information",
	Long:  versionDesc,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Version:", version.Version)
		fmt.Println("Git Commit:", version.GitCommit)
		fmt.Println("Git Tree State:", version.GitTreeState)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
