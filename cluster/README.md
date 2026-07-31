# Cluster 구성

> ⚠️ **TODO** — 이 폴더는 VM에서 실제 구성 내용을 채워야 합니다.
> `scripts/dump-cluster.sh`를 VM에서 실행하면 `nimbus-dump/cluster/`에 힌트가 나옵니다.

kubeadm으로 단일 노드 클러스터를 부트스트랩했습니다.

## 채워야 할 내용

- [ ] `kubeadm init` 실행 옵션 (pod-network-cidr 등)
- [ ] 컨테이너 런타임: **containerd** (버전)
- [ ] CNI: **Calico** (설치 명령/매니페스트 버전)
- [ ] control-plane 단일 노드에서 워크로드 스케줄되도록 taint 제거 여부
  (`kubectl taint nodes --all node-role.kubernetes.io/control-plane-`)
- [ ] ingress-nginx 설치 방법 (helm/manifest)
- [ ] socat 포트 포워딩 (:26117 → NodePort 30707) systemd 유닛

## 확인 명령 (포폴 캡처용)

```bash
kubectl get nodes -o wide          # 런타임/버전
kubectl get pods -n kube-system    # calico 파드 확인
```
