# Cluster

`kubeadm`으로 부트스트랩한 단일 노드 클러스터.

## 환경

| 항목 | 값 |
|---|---|
| Kubernetes | v1.35.6 |
| 컨테이너 런타임 | containerd 2.2.5 |
| OS | Ubuntu 22.04.5 LTS (kernel 5.15) |
| 노드 | `gsmsv` 1대 (control-plane) |
| CNI | Calico (Tigera operator, `calico-system` 네임스페이스) |
| Ingress Controller | ingress-nginx (helm chart 4.15.1 / app v1.15.1) |

## 단일 노드 구성

control-plane 노드 1대만 존재하며, control-plane taint를 제거해 이 노드에서 사용자 워크로드까지 스케줄한다.

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

`kube-system`은 표준 kubeadm 구성(coredns, etcd, kube-apiserver, kube-controller-manager, kube-proxy, kube-scheduler)으로 이루어진다.

## 외부 노출 경로

VM public IP(158.247.251.109)의 `:26117` → socat → NodePort 30707 → ingress-nginx → 각 서비스.
ingress-nginx가 Host 헤더 기반으로 라우팅한다.

| Host | 대상 |
|---|---|
| `console.158.247.251.109.sslip.io` | 배포 콘솔 |
| `grafana.158.247.251.109.sslip.io` | Grafana |
| `<app>.158.247.251.109.sslip.io` | 사용자 배포 앱 (동적 생성) |

## 상태 확인

```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl get ingress -A
helm list -A
```
