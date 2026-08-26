## Verify Git Account
```bash
git config user.name
git config user.email
```


## Commit

```bash
git add .

git status

git commit -m "Complete TravelMemory AWS deployment using Terraform and Ansible"

git push origin main
```

## Push from Laptop (WSL) — Recommended Workflow


Step 1 — Copy Code from EC2 → Laptop

From WSL:

```bash 
scp -i ~/.ssh/travel-key.pem -r \
ubuntu@<ELASTIC_IP>:/opt/travelmemory/backend \
~/projects/TerraformHV/mern-terraform-ansible/

Same for frontend if needed:

scp -i ~/.ssh/travel-key.pem -r \
ubuntu@<ELASTIC_IP>:/opt/travelmemory/frontend \
~/projects/TerraformHV/mern-terraform-ansible/

```
This copies only project code.

Step 2 — Review
```bash
cd ~/projects/TerraformHV/mern-terraform-ansible

git diff
```
Verify only intended changes.

Step 3 — Commit
```bash
git add .

git commit -m "Complete TravelMemory deployment using Terraform and Ansible"
```

Step 4 — Push
```bash
git push origin main
```

This uses your GitHub Account 2 already configured in WSL/VS Code.

Recommendation: Push from WSL instead of EC2.

---

<br>

##  To check what changes are in commits before push

#### To see exactly what changes are in your local commits before you push them to the remote server, you can use the `git log` or `git diff` commands.

Here are the best ways to preview your changes based on how much detail you want to see:

### 1. See a summary of changes (File names & stats)

If you just want a quick list of which files were changed and how many lines were added or removed, run:

    ```bash
    git diff origin/main..main --stat
    ```

### 2. See the exact code changes (The full diff)

To see every single line of code that was added or deleted in your local commits compared to the server, run:

    ```bash
    git diff origin/main..main
    ```
    > Tip: Press q to exit this view if the file is long.

### 3. See the commit message and history

If you want to view the commit message, author, date, and hash of the specific commit(s) you are about to push, run:

    ```bash
    git log origin/main..main
    ```

### 4. See commit messages alongside code changes

To see both the commit messages and the full code changes combined into one chronological view, run:

    ```bash
    git log -p origin/main..main
    ```

---

## To safely undo your local commit so you can pull

To safely undo your local commit so you can pull the updated changes from your other location, you need to use git reset

### Hard Reset

Run the following command in your terminal:

```bash
git reset --hard origin/main
```

#### What this does:
- `git reset --hard force` fully rewinds your local branch.
- `origin/main` tells Git to match your local files exactly to what the server last knew about (before you made that extra local commit).
- This completely **deletes your local unpushed commit** and cleans your working directory.

#### What to do next:

Once your branch is reset, you can safely pull down the commits you pushed from the other location:

```bash
git pull
```

### Alternative To Keep your local changes just in case:

If you are worried that your local commit has code you might want to look at later, do not use --hard. Instead, run:

```bash
git reset --soft origin/main
```

This removes the commit but **keeps your modified files** in your staging area. You can then run `git stash` to temporarily hide them, `git pull` your remote changes, and `git stash pop` to bring your files back.


### 1. How to view stashed files

To see your saved stashes and the files inside them, use these commands:
- List all stashes:

```bash
git stash list
```

This shows your stashes with their index numbers (e.g., stash@{0}, stash@{1}) and descriptions.
- See which files are in a specific stash:

```bash
git stash show stash@{0}
```

- See the actual code changes inside a stash:

```bash
git stash show -p stash@{0}
```

### 2. Can you give a tag or title to a stash?

Yes, you can give a custom message (title) to a stash, but you should not use the word "tag" (as git tag is a separate feature for marking release points in commit history).To save your work with a clear, descriptive title, use the -m (message) flag:bashgit stash push -m "My descriptive custom title here"
Use code with caution.When you run git stash list, you will see your custom title next to the stash index, making it easy to identify later.

### 3. The process after adding a title to a stash

Once your work is safely stashed with a title, your working directory becomes clean. Here is the standard workflow to follow next:

#### Step A: Do your urgent work

Since your messy or uncommitted code is safely tucked away, you can now freely switch branches, fix bugs, or pull down the latest changes from your other location:

```bash
git pull
```

#### Step B: Identify your stash

When you are ready to bring your changes back, look at your list to find the correct stash index using your custom title:

```bash
git stash list
```

#### Step C: Bring your changes back

You have two choices for restoring your stashed work:

- **Option 1: Apply and Delete (Recommended)**

This brings the changes back into your working directory and immediately deletes the stash from your list to keep things clean:'

```bash
git stash pop stash@{0}
```

- **Option 2: Apply and Keep**

This brings the changes back but leaves a copy in your stash list just in case you want to apply it elsewhere later:

```bash
git stash apply stash@{0}
```

#### Step D: Clean up (If you used Option 2)

If you used apply instead of pop, remember to delete the stash manually once you are completely done with it:

```bash
git stash drop stash@{0}
```