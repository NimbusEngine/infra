# Cluster 구성

`kubeadm`으로 부트스트랩한 **단일 노드** 클러스터.

## 환경

| 항목 | 값 |
|---|---|
| Kubernetes | v1.35.6 |
| 컨테이너 런타임 | containerd 2.2.5 |
| OS | Ubuntu 22.04.5 LTS (kernel 5.15) |
| 노드 | `gsmsv` 1대 (control-plane) |
| CNI | Calico (Tigera operator, `calico-system` 네임스페이스) |
| Ingress Controller | ingress-nginx (helm chart 4.15.1 / app v1.15.1) |

## 단일 노드 특성

- control-plane 노드 1대만 존재. **control-plane taint를 제거**하여 이 노드에서 사용자 워크로드까지 스케줄되도록 구성.
  ```bash
  kubectl taint nodes --all node-role.kubernetes.io/control-plane-
  ```
- `kube-system` 구성: coredns, etcd, kube-apiserver, kube-controller-manager, kube-proxy, kube-scheduler (표준 kubeadm 구성)

## 외부 노출 경로

VM public IP(158.247.251.109)의 `:26117` → socat → NodePort 30707 → ingress-nginx → 각 서비스.
ingress-nginx가 Host 헤더 기반으로 라우팅하며, 현재 등록된 호스트:

| Host | 대상 |
|---|---|
| `console.158.247.251.109.sslip.io` | 배포 콘솔 |
| `grafana.158.247.251.109.sslip.io` | Grafana |
| `<app>.158.247.251.109.sslip.io` | 사용자 배포 앱 (동적 생성) |

## 상태 확인 명령 (포폴 캡처용)

```bash
kubectl get nodes -o wide          # 런타임/버전
kubectl get pods -A                # 전체 파드
kubectl get ingress -A             # 호스트 라우팅
helm list -A                       # 설치된 차트
```

## TODO (VM에서 추가 확인)

- [ ] `kubeadm init` 실행 옵션 (pod-network-cidr 등) — 기억나면 기록
- [ ] socat / backend systemd 유닛 파일 (`systemctl cat`)
