# ArgoCD Demo Application

This is a simple demo application for testing ArgoCD deployments with two versions.

## Files Created

- `Dockerfile` - Container definition using nginx
- `index.html` - Version 1 of the application (gray background)
- `index-v2.html` - Version 2 of the application (blue background)
- `deployment.yml` - Kubernetes deployment manifest
- `service.yml` - Kubernetes service manifest
- `build-and-push.sh` - Script to build and push both versions to ECR

## Setup Instructions

### 1. Images Already Built and Pushed ✅

Both versions are already available in your ECR repository:
- **v1**: `public.ecr.aws/a8f2g6a2/argo-eks-demo:v1`
- **v2**: `public.ecr.aws/a8f2g6a2/argo-eks-demo:v2`

### 2. Deploy to Kubernetes

```bash
# Deploy the application
kubectl apply -f deployment.yml
kubectl apply -f service.yml

# Check deployment status
kubectl get pods
kubectl get svc
```

### 3. Setup ArgoCD Application

Since you already have ArgoCD running on EKS, create the application using one of these methods:

**Option A: ArgoCD UI**
1. Access your ArgoCD UI
2. Click "NEW APP"
3. Fill in:
   - **Application Name**: `argocd-demo`
   - **Project**: `default`
   - **Repository URL**: Your Git repository URL
   - **Path**: `.` (root directory)
   - **Cluster URL**: `https://kubernetes.default.svc`
   - **Namespace**: `default`
4. Enable **Auto-Sync** and **Self Heal**
5. Click **CREATE**

**Option B: ArgoCD CLI**
```bash
argocd app create argocd-demo \
  --repo https://github.com/YOUR_USERNAME/YOUR_REPO \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```

### 4. Test ArgoCD Sync

To test ArgoCD automatic sync:

1. **Change image version** in `deployment.yml`:
   ```yaml
   # Change from:
   image: public.ecr.aws/a8f2g6a2/argo-eks-demo:v1
   # To:
   image: public.ecr.aws/a8f2g6a2/argo-eks-demo:v2
   ```

2. **Commit and push** to your Git repository:
   ```bash
   git add deployment.yml
   git commit -m "Update to v2"
   git push
   ```

3. **Watch ArgoCD sync** - ArgoCD will automatically detect the change and deploy v2

### 5. Rebuild Images (if needed)

If you want to rebuild the images:

```bash
# Build and push v1
./build-v1.sh

# Build and push v2  
./build-v2.sh

# Or build both
./build-and-push.sh
```

## Version Differences

- **v1**: Gray background, "Version: v1"
- **v2**: Blue background, "Version: v2", "Updated!" text

## ArgoCD Application Example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argocd-demo
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-username/your-repo
    targetRevision: HEAD
    path: .
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```